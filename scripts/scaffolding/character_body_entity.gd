class_name CharacterBodyEntity
extends Entity

var body : CharacterBody2D = self as Variant

func _physics_process(_delta: float) -> void:
    if !is_multiplayer_authority(): return
    body.move_and_slide()
