class_name Networking
extends VBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var name_edit: LineEdit = $HBoxContainer/LineEdit2
@onready var connect_button: Button = $ConnectButton
@onready var host_button: Button = $HostButton

func _ready() -> void:
    connect_button.pressed.connect(_on_connect)
    host_button.pressed.connect(_on_host)
    name_edit.text_changed.connect(_on_name_changed)
    connect_button.disabled = true
    host_button.disabled = true

func _on_name_changed(new_text: String) -> void:
    var disabled := new_text == ""
    connect_button.disabled = disabled
    host_button.disabled = disabled
 
func _on_connect() -> void:
    var ip_and_port := _ip_and_port(line_edit.text)
    NetworkManager.join(ip_and_port[0],int(ip_and_port[1]), name_edit.text)
    visible = false
    
func _on_host() -> void:
    var ip_and_port := _ip_and_port(line_edit.text)
    NetworkManager.host(int(ip_and_port[1]), name_edit.text)
    visible = false
    

func _ip_and_port(text: String) -> PackedStringArray:
    if !text.contains(":"):
        return ["127.0.0.1", text]
    
    return text.split(":")
