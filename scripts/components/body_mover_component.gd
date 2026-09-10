class_name BodyMoverComponent
extends Component

const SPEED: float = 7000.0

func _on_joystick(joystick: Vector2, delta: float) -> void:
    if !is_multiplayer_authority(): return
    parent.body.velocity = joystick * SPEED * delta
