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

func get_spawner(phase: int, type: GDScript) -> PhaseAwareSpawner:
    return get_phase(phase).get_spawner(type)

func get_spawners(type: GDScript) -> Array[PhaseAwareSpawner]:
    var to_return : Array[PhaseAwareSpawner] = []
    var phases := phase_spawner.get_phases()
    for phase: Phase in phases:
        to_return.append(phase.get_spawner(type))
    return to_return

func create_new_phase() -> int:
    var new_phase_no := phase_count
    var phase := phase_spawner.spawn(new_phase_no) as Phase
    phase.stale.connect(_on_phase_stale.bind(new_phase_no))
    phase_count += 1
    await get_tree().process_frame
    return new_phase_no

func _on_phase_stale(num: int) -> void:
    NetworkManager.do_print("cleaning up stale phase (%s)" % num)
    get_phase(num).queue_free()

func update_view(phase: int) -> void:
    phase_view.texture = get_phase(phase).get_texture()

@rpc('authority', 'call_local')
func update_view_remote(phase: int) -> void:
    NetworkManager.do_print("Receieved update view command to %s" % phase);
    update_view(phase)
