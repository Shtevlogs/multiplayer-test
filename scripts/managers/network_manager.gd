extends Node

signal requires_new_login(msg: String)

var peer: ENetMultiplayerPeer
var pid: int
var player_name: String

func host(port: int, n: String) -> void:
    NotificationManager.set_message("hosting on port %s" % port, 1.0)
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
    NotificationManager.set_message("joining... %s:%s" % [ip,port])
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    player_name = n
    
    do_print('joining %s:%s' % [ip, port])
    
    multiplayer.connected_to_server.connect(_on_connected, CONNECT_ONE_SHOT)
    multiplayer.connection_failed.connect(_on_connection_failed, CONNECT_ONE_SHOT)
    multiplayer.server_disconnected.connect(_on_server_disconnected, CONNECT_ONE_SHOT)

func _on_connected() -> void:
    NotificationManager.hide()
    #Send player information (right now just name)
    IdentityManager.register_identity(pid, player_name)

func _on_connection_failed() -> void:
    multiplayer.connected_to_server.disconnect(_on_connected)
    multiplayer.server_disconnected.disconnect(_on_server_disconnected)
    requires_new_login.emit("Connection failed!")

func _on_server_disconnected() -> void:
    multiplayer.connection_failed.disconnect(_on_connection_failed)
    requires_new_login.emit("Server disconnected")

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
