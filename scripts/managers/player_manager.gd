extends Node

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)

func _on_peer_connected(id: int) -> void:
    if !multiplayer.is_server(): return
    spawn_peer(id, 0)

func spawn_peer(peer_id: int, phase : int) -> void:
    if !multiplayer.is_server(): return
    var player_spawner := PhaseManager.get_player_spawner(phase)
    player_spawner.spawn(peer_id)
