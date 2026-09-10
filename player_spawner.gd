class_name PlayerSpawner
extends MultiplayerSpawner

const PLAYER : PackedScene = preload("uid://co0dy4rvhwv5g")

func _ready() -> void:
    spawn_function = _spawn_player

func _spawn_player(id: int) -> Node:
    NetworkManager.I.do_print("Spawning Player ... %s" %id)
    var new_player := PLAYER.instantiate() as Entity
    new_player.pid = id
    new_player.name = "Player_%s" % id
    return new_player
