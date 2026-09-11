class_name SceneSpawner
extends PhaseAwareSpawner

func _ready() -> void:
    spawn_function = _spawn_scene

func _spawn_scene(scene_no: int) -> Node:
    NetworkManager.do_print("Spawning Scene ... %s" %scene_no)
    var prefab := SceneManager.SCENES[scene_no]
    var node := prefab.instantiate() as Phaseable
    node.phase = phase
    return node
