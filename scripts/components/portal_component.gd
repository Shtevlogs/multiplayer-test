class_name PortalComponent
extends Component

@export var target_scene := 1

func _post_ready() -> void:
    (parent as Area2DEntity).area_2d.body_entered.connect(_on_body_entered)
    
func _on_body_entered(node: Node2D) -> void:
    if !multiplayer.is_server(): return
    var entity := node as Entity
    if !entity || !entity.has_component_of_type(InputComponent): return #TODO: better way to tell the entity is a player
    
    var phase := SceneManager.request_scene(target_scene)
    if phase >= 0:
        entity.change_phase.rpc_id(entity.get_multiplayer_authority(), phase)
