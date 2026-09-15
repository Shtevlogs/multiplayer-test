extends Node

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
    if !multiplayer.is_server(): return
    spawn_peer(id, 0)

func _on_peer_disconnected(id: int) -> void:
    if !multiplayer.is_server(): return
    var players := get_tree().get_nodes_in_group(&"Players")
    for p: Entity in players:
        if p.pid == id:
            p.queue_free()

func spawn_peer(peer_id: int, phase : int) -> void:
    if !multiplayer.is_server(): return
    var player_spawner : PlayerSpawner = PhaseManager.get_spawner(phase, PlayerSpawner)
    player_spawner.spawn(peer_id)
