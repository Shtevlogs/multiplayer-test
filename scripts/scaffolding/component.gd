class_name Component
extends Node

var parent : Entity

func _ready() -> void:
    parent = get_parent()
    parent.register_component(self)

func _post_ready() -> void:
    pass
