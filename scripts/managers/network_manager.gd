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
    SceneManager.request_scene(SceneManager.WORLD)
    PlayerManager.spawn_self()
    
    #scene_manager.spawn_scene(SceneManager.WORLD_2, 1)
    
func join(ip: String, port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('joining %s:%s' % [ip, port])
    

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
