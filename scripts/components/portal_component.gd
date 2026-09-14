class_name PortalComponent
extends ServerComponent

@export var target_scene := 1

func _post_ready() -> void:
    var a2d := (parent as Area2DEntity).area_2d
    if !a2d.body_entered.is_connected(_on_body_entered):
        a2d.body_entered.connect(_on_body_entered)
    
func _on_body_entered(node: Node2D) -> void:
    var entity := node as Entity
    if !entity || !entity.has_component_of_type(InputComponent): return #TODO: better way to tell the entity is a player
    
    var phase := await SceneManager.request_scene(target_scene)
    if phase >= 0:
        var peer_id := entity.get_multiplayer_authority()
        #entity.change_phase.rpc_id(entity.get_multiplayer_authority(), phase)
        
        entity.cleanup.rpc()
        
        # had to do this because of circ reference?
        #TODO: make it so that doesn't happen? ...ffs
        $/root/PlayerManager.call_deferred(&'spawn_peer', peer_id, phase)
        $/root/PhaseManager.update_view_remote.rpc_id(peer_id, phase)
