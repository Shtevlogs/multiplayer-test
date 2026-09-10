class_name NetworkManager
extends Node

static var I : NetworkManager
func _ready() -> void:
    I = self
    
@onready var scene_spawner: MultiplayerSpawner = $"../../SceneSpawner"
@onready var player_spawner: MultiplayerSpawner = $"../../PlayerSpawner"
@onready var networking: Networking = $"../../CanvasLayer/Networking"

var peer: ENetMultiplayerPeer
var pid: int

func host(port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer
    
    pid = peer.get_unique_id()
    
    do_print('hosting %s' % [port])
    
    multiplayer.peer_connected.connect(_on_peer_connected)
    
    # THESE NEED TO BE IN ORDER
    SceneManager.I.change_scene(SceneManager.WORLD)
    player_spawner.spawn(1)
    networking.visible = false
    
func join(ip: String, port: int) -> void:
    peer = ENetMultiplayerPeer.new()
    peer.create_client(ip, port)
    multiplayer.multiplayer_peer = peer
    
    pid = peer.get_unique_id()
    
    do_print('joining %s:%s' % [ip, port])
    
    networking.visible = false

func _on_peer_connected(id: int) -> void:
    if !multiplayer.is_server(): return
    # spawn a new player
    player_spawner.spawn(id)

func do_print(text: String) -> void:
    print("[%s]: %s" % [pid,text])
