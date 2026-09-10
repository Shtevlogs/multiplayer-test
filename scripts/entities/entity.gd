class_name Entity
extends Node2D

const SPEED: float = 5000.0

var body : CharacterBody2D

@export var pid : int

func _enter_tree() -> void:
    set_multiplayer_authority(pid)

func _ready() -> void:
    body = self as Variant #it's a dirty trick, but I love it <3
    NetworkManager.I.do_print("player is spawned %s" % pid)
    if !is_multiplayer_authority(): return
    position += Vector2.UP * randf_range(-120,120) + Vector2.RIGHT * randf_range(-120,120)
    
func _physics_process(delta: float) -> void:
    if !is_multiplayer_authority(): return
    body.velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * SPEED * delta
    body.move_and_slide()
