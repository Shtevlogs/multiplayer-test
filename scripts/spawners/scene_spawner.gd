class_name SceneSpawner
extends PhaseAwareSpawner

var spawned_scene_no : int = -1
var spawned_scene : Phaseable = null

func _ready() -> void:
    spawn_function = _spawn_scene

func _spawn_scene(scene_no: int) -> Node:
    clear_scene()
    NetworkManager.do_print("Spawning Scene ... %s" %scene_no)
    var prefab := SceneManager.SCENES[scene_no]
    var node := prefab.instantiate() as Phaseable
    node.phase = phase
    spawned_scene_no = scene_no
    spawned_scene = node
    return node

func is_scene_active(scene_no: int) -> bool:
    return spawned_scene_no == scene_no

func clear_scene() -> void:
    if spawned_scene:
        spawned_scene.queue_free()
    spawned_scene = null
    spawned_scene_no = -1
    
