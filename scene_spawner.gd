class_name SceneSpawner
extends MultiplayerSpawner

const SCENE = preload("uid://xgbtjip1bena")

func _ready() -> void:
    spawn_function = _spawn_player

func _spawn_player(scene: PackedScene) -> Node:
    print(scene)
    return SCENE.instantiate()
