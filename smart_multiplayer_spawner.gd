class_name SmartMultiplayerSpawner
extends MultiplayerSpawner

const PLAYER : PackedScene = preload("uid://co0dy4rvhwv5g")

var pid : int = 1

func _enter_tree() -> void:
    NetworkManager.I.do_print('setting smart spawner auth to %s' % pid)
    set_multiplayer_authority(pid)

func _ready() -> void:
    spawn_function = _on_spawned
    if !multiplayer.is_server(): return
    multiplayer.peer_connected.connect(_on_peer_connected)
    NetworkManager.I.do_print("I'm spawning my player now >.>")
    await get_tree().process_frame
    spawn(pid)

func _on_spawned(id: int) -> Node:
    var player: Entity = PLAYER.instantiate()
    NetworkManager.I.do_print("setting new Player pid to %s" % id)
    player.pid = id
    player.name = "Player_%s" % pid
    return player

func _on_peer_connected(id: int) -> void:
    if multiplayer.is_server():
        spawn(id)
