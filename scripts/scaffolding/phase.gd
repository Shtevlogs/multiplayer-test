class_name Phase
extends SubViewport

const STALE_TIME := 3.0

signal stale()

var empty_time := 0.0

func _process(delta: float) -> void:
    if get_child_count() <= 3:
        empty_time += delta
    else:
        empty_time = 0.0
    if empty_time > STALE_TIME:
        stale.emit()
