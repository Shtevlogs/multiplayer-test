class_name ServerComponent
extends Component

func _enter_tree() -> void:
    if !multiplayer.is_server(): queue_free()
