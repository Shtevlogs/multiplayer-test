extends Node

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)

func _on_peer_connected(id: int) -> void:
    if !multiplayer.is_server(): return
    var player_spawner := PhaseManager.get_player_spawner(0)
    player_spawner.spawn(id)

func spawn_self(phase := 0) -> void:
    var player_spawner := PhaseManager.get_player_spawner(phase)
    player_spawner.spawn(multiplayer.get_unique_id())

func request_spawn_self(phase := 0) -> void:
    var player_spawner := PhaseManager.get_player_spawner(phase)
    player_spawner.request_spawn.rpc_id(1, multiplayer.get_unique_id())
