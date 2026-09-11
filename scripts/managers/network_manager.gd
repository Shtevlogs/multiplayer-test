extends Node

var peer: ENetMultiplayerPeer
var pid: int

func host(port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('hosting %s' % [port])
    
    # THESE 2 NEED TO BE IN ORDER
    await SceneManager.request_scene(SceneManager.WORLD)
    PlayerManager.spawn_peer(0, 0)
    
func join(ip: String, port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('joining %s:%s' % [ip, port])
    

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
