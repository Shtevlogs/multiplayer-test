class_name Networking
extends VBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var name_edit: LineEdit = $HBoxContainer/LineEdit2
@onready var connect_button: Button = $ConnectButton
@onready var host_button: Button = $HostButton
@onready var identity_options: OptionButton = $IdentityOptions

func _ready() -> void:
    connect_button.pressed.connect(_on_connect)
    host_button.pressed.connect(_on_host)
    name_edit.text_changed.connect(_on_name_changed)
    identity_options.item_selected.connect(_on_identity_selected)
    connect_button.disabled = true
    host_button.disabled = true
    
    NetworkManager.requires_new_login.connect(_on_requires_new_login)
    IdentityManager.identities_loaded.connect(_on_identities_loaded)

func _on_identities_loaded() -> void:
    if IdentityManager.my_identity:
        name_edit.text = IdentityManager.my_identity.player_name
        name_edit.text_changed.emit(name_edit.text)
    identity_options.clear()
    identity_options.add_item('Identities')
    identity_options.selected = 0
    for identity: IdentityModel in IdentityManager.identities:
        identity_options.add_item(identity.player_name)
        
func _on_identity_selected(i: int) -> void:
    var identity_name := identity_options.get_item_text(i)
    name_edit.text = identity_name
    name_edit.text_changed.emit(name_edit.text)
        
func _on_requires_new_login(msg: String) -> void:
    NotificationManager.set_message(msg)
    visible = true

func _on_name_changed(new_text: String) -> void:
    var disabled := new_text == ""
    connect_button.disabled = disabled
    host_button.disabled = disabled
 
func _on_connect() -> void:
    IdentityManager.set_default_identity(name_edit.text)
    var ip_and_port := _ip_and_port(line_edit.text)
    NetworkManager.join(ip_and_port[0],int(ip_and_port[1]), name_edit.text)
    visible = false
    
func _on_host() -> void:
    IdentityManager.set_default_identity(name_edit.text)
    var ip_and_port := _ip_and_port(line_edit.text)
    NetworkManager.host(int(ip_and_port[1]), name_edit.text)
    visible = false
    
func _ip_and_port(text: String) -> PackedStringArray:
    if !text.contains(":"):
        return ["127.0.0.1", text]
    
    return text.split(":")
