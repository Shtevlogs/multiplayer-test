class_name NetworkManager
extends Node

static var I : NetworkManager
func _ready() -> void:
    I = self
    
@onready var scene_spawner: MultiplayerSpawner = $"../../SceneSpawner"
@onready var player_spawner: MultiplayerSpawner = $"../../PlayerSpawner"

var peer: ENetMultiplayerPeer
var pid: int

func host(port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    
    pid = peer.get_unique_id()
    
    do_print('hosting %s' % [port])
    
    multiplayer.peer_connected.connect(_on_peer_connected)
    
    Main.I.start()
    await get_tree().process_frame
    player_spawner.spawn(1)

func join(ip: String, port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    
    pid = peer.get_unique_id()
    
    do_print('joining %s:%s' % [ip, port])
    
    Main.I.start()

func _on_peer_connected(id: int) -> void:
    if !multiplayer.is_server(): return
    # spawn a new player
    player_spawner.spawn(id)
    

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
