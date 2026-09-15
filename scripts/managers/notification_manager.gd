extends Node

@onready var message_box : Control = $/root/Main/CanvasLayer/MessageBox
@onready var message : Label = $/root/Main/CanvasLayer/MessageBox/Panel/Label

func _ready() -> void:
    message_box.visible = false

func set_message(msg : String, time: float = 0.0) -> void:
    message.text = msg
    message_box.visible = true
    if time > 0:
        await get_tree().create_timer(time).timeout
        hide()
    
func hide() -> void:
    message_box.visible = false
