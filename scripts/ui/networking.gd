class_name Networking
extends VBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var connect_button: Button = $ConnectButton
@onready var host_button: Button = $HostButton

func _ready() -> void:
    connect_button.pressed.connect(_on_connect)
    host_button.pressed.connect(_on_host)
    
func _on_connect() -> void:
    var ip_and_port := _ip_and_port(line_edit.text)
    NetworkManager.I.join(ip_and_port[0],int(ip_and_port[1]))
    
func _on_host() -> void:
    var ip_and_port := _ip_and_port(line_edit.text)
    NetworkManager.I.host(int(ip_and_port[1]))
    

func _ip_and_port(text: String) -> PackedStringArray:
    if !text.contains(":"):
        return ["127.0.0.1", text]
    
    return text.split(":")
