class_name PhaseSpawner
extends MultiplayerSpawner

const PHASE : PackedScene = preload("uid://s5fu1gkeonjv")

func _ready() -> void:
    spawn_function = _spawn_phase

func _spawn_phase(phase_no: int) -> Node:
    NetworkManager.do_print("Spawning Phase ... %s" %phase_no)
    var phase := PHASE.instantiate() as SubViewport
    phase.name = "Phase%s" % phase_no
    phase.world_2d = World2D.new()
    return phase

func get_phase(num: int) -> SubViewport:
    var container := get_node(spawn_path)
    return container.get_node("Phase%s" % num)

func create_phase(num: int) -> bool:
    var container := get_node(spawn_path)
    if !container.has_node("Phase%s" % num):
        spawn(num)
        return true
    return false
    
