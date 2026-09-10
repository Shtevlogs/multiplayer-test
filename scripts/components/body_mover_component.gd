class_name BodyMoverComponent
extends Component

const SPEED: float = 7000.0

func _physics_process(delta: float) -> void:
    if !is_multiplayer_authority(): return
    parent.body.velocity = Input.get_vector("a","d","w","s") * SPEED * delta
