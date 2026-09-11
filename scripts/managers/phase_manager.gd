extends Node

@onready var phase_view: TextureRect = $"/root/Main/CanvasLayer/PhaseView"
@onready var phase_spawner: PhaseSpawner = $"/root/Main/Managers/PhaseSpawner"
@onready var phases: Array[Phase] = [
    $"/root/Main/SceneRoot/SubViewportContainer/Phase0"
]
var scene_assignments: Array[int] = [
    -1
]

var phase_views: Array[ViewportTexture] = [ ]

var phase_count := 1

func _ready() -> void:
    for i: int in phases.size():
        var phase := phases[i]
        phase_views.append(phase.get_texture())
        phase.get_node('PlayerSpawner').phase = i
        phase.get_node('SceneSpawner').phase = i
    phase_view.texture = phase_views[0]

func get_player_spawner(phase: int) -> PlayerSpawner:
    var idx := get_phase_idx(phase)
    return phases[idx].get_node("PlayerSpawner")
    
func get_scene_spawner(phase: int) -> SceneSpawner:
    var idx := get_phase_idx(phase)
    return phases[idx].get_node("SceneSpawner")

func get_scene_phase(scene_no: int) -> int:
    for i: int in scene_assignments.size():
        var assignment := scene_assignments[i]
        if assignment == scene_no:
            return int(phases[i].name.substr(5))
    return -1

func reserve_unused_phase(scene_no: int) -> int:
    for i: int in scene_assignments.size():
        var assignment := scene_assignments[i]
        if assignment == -1:
            scene_assignments[i] = scene_no
            return i
    if !multiplayer.is_server():
        push_error("I didn't plan for this!")
        return -1
    
    var phase_no := await create_new_phase()
    var idx := get_phase_idx(scene_no)
    scene_assignments[idx] = scene_no
    return phase_no

func create_new_phase() -> int:
    var new_phase_no := phase_count
    var phase := phase_spawner.spawn(new_phase_no) as Phase
    phase.stale.connect(_on_phase_stale.bind(new_phase_no))
    track_new_phase.rpc()
    await get_tree().process_frame
    return new_phase_no

@rpc('authority', 'call_local')
func track_new_phase() -> void:
    var phase := get_phase(phase_count)
    
    phase_count += 1
    phases.append(phase)
    scene_assignments.append(-1)
    phase_views.append(phase.get_texture())

@rpc('authority', 'call_local')
func drop_phase(num: int) -> void:
    var phase := get_phase(num)
    
    var idx := phases.find(phase)
    if idx < 0: return
    
    NetworkManager.do_print('dereferencing phase %s (scene %s)' % [num, scene_assignments[idx]])
    
    phases.remove_at(idx)
    scene_assignments.remove_at(idx)
    phase_views.remove_at(idx)
    
    if multiplayer.is_server():
        NetworkManager.do_print('despawning phase %s' % num)
        phase.queue_free()

func get_phase(phase_no: int) -> Phase:
    return phase_spawner.get_node(phase_spawner.spawn_path).get_node('Phase%s' % phase_no)

func get_phase_idx(phase_no: int) -> int:
    return phases.find(get_phase(phase_no))

func _on_phase_stale(num: int) -> void:
    drop_phase.rpc(num)

func is_phase_open(phase: int, to_scene: int) -> bool:
    var idx := get_phase_idx(phase)
    return scene_assignments[idx] == to_scene

func update_view(phase: int) -> void:
    var idx := get_phase_idx(phase)
    phase_view.texture = phase_views[idx]

@rpc('authority', 'call_local')
func update_view_remote(phase: int) -> void:
    update_view(phase)
