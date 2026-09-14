extends Node

@onready var phase_view: TextureRect = $"/root/Main/CanvasLayer/PhaseView"
@onready var phase_spawner: PhaseSpawner = $"/root/Main/Managers/PhaseSpawner"

var phase_count := 1

func get_phase(no: int) -> Phase:
    var phases := phase_spawner.get_phases()
    var idx := phases.find_custom(func(phase: Phase): return phase._phase == no )

    if idx < 0:
        return null
    return phases[idx]

func get_player_spawner(phase: int) -> PlayerSpawner:
    return get_phase(phase).get_node("PlayerSpawner")
    
func get_scene_spawner(phase: int) -> SceneSpawner:
    return get_phase(phase).get_node("SceneSpawner")

func get_scene_phase(scene_no: int) -> int:
    var phases := phase_spawner.get_phases()
    for phase: Phase in phases:
        if phase.scene_assignment == scene_no:
            return phase.get_number()
    return -1

func reserve_unused_phase(scene_no: int) -> int:
    var phases := phase_spawner.get_phases()
    for phase: Phase in phases:
        if phase.scene_assignment == -1:
            phase.scene_assignment = scene_no
            return phase.get_number()
    
    if !multiplayer.is_server():
        push_error("I didn't plan for this!")
        return -1
    
    var phase_no := await create_new_phase()
    var phase := get_phase(phase_no)
    phase.scene_assignment = scene_no
    return phase_no

func create_new_phase() -> int:
    var new_phase_no := phase_count
    var phase := phase_spawner.spawn(new_phase_no) as Phase
    phase.stale.connect(_on_phase_stale.bind(new_phase_no))
    phase_count = phase_count + 1
    await get_tree().process_frame
    return new_phase_no

func _on_phase_stale(num: int) -> void:
    get_phase(num).queue_free()

func is_phase_open(phase: int, to_scene: int) -> bool:
    return get_phase(phase).scene_assignment == to_scene

func update_view(phase: int) -> void:
    phase_view.texture = get_phase(phase).get_texture()

@rpc('authority', 'call_local')
func update_view_remote(phase: int) -> void:
    NetworkManager.do_print("Receieved update view command to %s" % phase);
    update_view(phase)
