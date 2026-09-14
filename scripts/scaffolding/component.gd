class_name Component
extends Node

var parent : Entity

func _ready() -> void:
    if is_queued_for_deletion(): return
    parent = get_parent()
    parent.register_component(self)

func _post_ready() -> void:
    pass
