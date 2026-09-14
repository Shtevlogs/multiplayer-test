class_name SceneSpawner
extends PhaseAwareSpawner

func _ready() -> void:
    spawn_function = _spawn_scene
    
    for prefab : PackedScene in SceneManager.SCENES:
        SceneManager.SCENE_MOCKS.append(prefab.instantiate())

func _spawn_scene(scene_no: int) -> Node:
    NetworkManager.do_print("Spawning Scene ... %s" %scene_no)
    var prefab := SceneManager.SCENES[scene_no]
    var node := prefab.instantiate() as Phaseable
    node.phase = phase
    return node

func is_scene_active(scene_no: int) -> bool:
    var root := get_node(spawn_path)
    var mock : Phaseable = SceneManager.SCENE_MOCKS[scene_no]
    return root.find_child(mock.name, true, false) != null
