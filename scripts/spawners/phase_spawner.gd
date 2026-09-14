class_name PhaseSpawner
extends MultiplayerSpawner

const PHASE : PackedScene = preload("uid://s5fu1gkeonjv")

func _ready() -> void:
    spawn_function = _spawn_phase

func _spawn_phase(phase_no: int) -> Node:
    NetworkManager.do_print("Spawning Phase ... %s" %phase_no)
    var phase := PHASE.instantiate() as SubViewport
    phase.name = "Phase%s" % phase_no
    phase._phase = phase_no
    phase.find_child("PlayerSpawner").phase = phase_no
    phase.find_child("SceneSpawner").phase = phase_no
    phase.world_2d = World2D.new()
    return phase

func get_phases() -> Array[Phase]:
    var to_return : Array[Phase]
    to_return.append_array(get_node(spawn_path).get_children())
    return to_return
