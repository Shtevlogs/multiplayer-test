extends Node

var peer: ENetMultiplayerPeer
var pid: int

func host(port: int, n: String) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('hosting %s' % [port])
    
    IdentityManager.register_identity(1, n)

    # THESE 2 NEED TO BE IN ORDER
    await SceneManager.request_scene(SceneManager.WORLD)
    PlayerManager.spawn_peer(1, 0)
    
func join(ip: String, port: int, n: String) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('joining %s:%s' % [ip, port])
    
    multiplayer.connected_to_server.connect(_on_connected.bind(n))

func _on_connected(n: String) -> void:
    #Send player information (right now just name)
    IdentityManager.register_identity(pid, n)

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
