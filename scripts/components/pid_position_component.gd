class_name PIDPositionComponent
extends Component

static var idx := 0

func _post_ready() -> void:
    do_positioning(idx)
    idx += 1
    
func do_positioning(i:int) -> void:
    parent.position = Vector2(-100 + 25 * i, 100)
