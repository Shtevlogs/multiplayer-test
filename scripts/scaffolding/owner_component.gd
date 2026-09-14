class_name OwnerComponent
extends Component

func _enter_tree() -> void:
    if !is_multiplayer_authority(): queue_free()
