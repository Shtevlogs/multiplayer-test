class_name Main
extends Node2D

const SCENE : PackedScene = preload("uid://xgbtjip1bena")

@onready var scene_root: Node2D = $SceneRoot
@onready var networking: Networking = $CanvasLayer/Networking

static var I : Main
func _ready() -> void:
    I = self
    
    var args := OS.get_cmdline_args()
    if args.has("down_lefty"):
        get_window().position -= Vector2i(600,0)

func _input(event:InputEvent) -> void:
    var key_pressed := event as InputEventKey
    if !key_pressed:
        return
    if key_pressed.keycode == KEY_ESCAPE:
        get_tree().quit()

func start() -> void:
    NetworkManager.I.do_print("main start %s" % NetworkManager.I.pid)
    networking.visible = false
    if multiplayer.is_server():
        NetworkManager.I.scene_spawner.spawn(null)
    
