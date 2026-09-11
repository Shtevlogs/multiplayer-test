class_name PlayerSpawner
extends PhaseAwareSpawner

func _ready() -> void:
    spawn_function = _spawn_player

func _spawn_player(id: int) -> Node:
    NetworkManager.do_print("Spawning Player ... %s" %id)
    var new_player := PreloadManager.PLAYER.instantiate()
    new_player.pid = id
    new_player.phase = phase
    new_player.name = "Player_%s" % id
    return new_player

@rpc('any_peer', 'call_local')
func request_spawn(id: int) -> void:
    if !multiplayer.is_server(): return
    spawn(id)
