class_name SceneSpawner
extends MultiplayerSpawner

const SCENE = preload("uid://xgbtjip1bena")

func _ready() -> void:
    spawn_function = _spawn_scene

func _spawn_scene(scene_no: int) -> Node:
    NetworkManager.I.do_print("Spawning Scene ... %s" %scene_no)
    return SceneManager.SCENES[scene_no].instantiate()
