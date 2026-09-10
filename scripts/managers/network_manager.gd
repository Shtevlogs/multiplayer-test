class_name NetworkManager
extends Node

static var I : NetworkManager
func _ready() -> void:
    I = self
    
@onready var scene_manager: SceneManager = $"../SceneManager"
@onready var player_manager: PlayerManager = $"../PlayerManager"

var peer: ENetMultiplayerPeer
var pid: int

func host(port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('hosting %s' % [port])
    
    # THESE NEED TO BE IN ORDER
    scene_manager.change_scene(SceneManager.WORLD)
    player_manager.spawn_self()
    
func join(ip: String, port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    pid = peer.get_unique_id()
    
    do_print('joining %s:%s' % [ip, port])
    

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
