class_name RandomPositionComponent
extends Component

func _post_ready() -> void:
    parent.position += Vector2.UP * randf_range(-120,120) + Vector2.RIGHT * randf_range(-120,120)
    
