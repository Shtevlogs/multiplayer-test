extends Node

const IDENTITY_CACHE_PATH := &"user://identity.json"

signal identities_loaded()

var identities : Array[IdentityModel] = []
var my_identity : IdentityModel = null

func _ready() -> void:
    # load identities from file
    var identity_str : String = FileAccess.get_file_as_string(IDENTITY_CACHE_PATH)
    var idtts : Array = JSON.parse_string(identity_str) if identity_str else []

    for identity_dict : Dictionary in idtts:
        identities.append(Model.from_dict(identity_dict))
    
    if !identities.is_empty():
        my_identity = identities[0]
    
    await get_tree().process_frame
    
    identities_loaded.emit()

func _save_identities() -> void:
    var to_stringify : Array = []
    for identity: IdentityModel in identities:
        to_stringify.append(identity.as_dict())
    
    var file = FileAccess.open(IDENTITY_CACHE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify(to_stringify))

func set_default_identity(n: String) -> void:
    var idx := identities.find_custom(func(id: IdentityModel) -> bool: return id.player_name == n)
    if idx == -1:
        var new_identity := IdentityModel.new()
        new_identity.player_name = n
        identities.push_front(new_identity)
    else:
        var identity := identities[idx]
        identities.remove_at(idx)
        identities.push_front(identity)
    _save_identities()
        

func register_identity(pid: int, n: String) -> void:
    if pid != multiplayer.get_unique_id(): return
    
    # grab identity data, send to host
    var identity_i := identities.find_custom(func(identity: IdentityModel): return identity.player_name == n)
    if identity_i == -1:
        var new_identity := IdentityModel.new()
        new_identity.player_name = n
        new_identity.pid = pid
        identities.append(new_identity)
        identity_i = identities.size() - 1
        _save_identities()
    my_identity = identities[identity_i]
    
    recieve_identity.rpc_id(1, my_identity.as_dict())

@rpc('any_peer', 'call_local')
func recieve_identity(data : Dictionary) -> void:
    #var data : Dictionary = JSON.parse_string(s)
    var identity : IdentityModel = Model.from_dict(data)
    var identity_i := identities.find_custom(func(id: IdentityModel): return identity.player_name == id.player_name)
    if identity_i >= 0:
        NetworkManager.do_print("I remember %s" % identity.player_name)
        identities[identity_i] = identity
    else:
        NetworkManager.do_print("I don't remember %s" % identity.player_name)
        identities.append(identity)
    _save_identities()
    
#func store_identity(data: IdentityDataModel, name: String) -> void:
