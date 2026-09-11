class_name Entity
extends Phaseable

static var _entity_rep_config : SceneReplicationConfig = SceneReplicationConfig.new()

var pid : int
var components : Array[Component] = []

func _init() -> void:
    var entity_sync := MultiplayerSynchronizer.new()
    entity_sync.replication_config = get_rep_config()
    entity_sync.set_script(EntitySyncComponent)
    add_child(entity_sync)

func get_rep_config() -> SceneReplicationConfig:
    return _entity_rep_config

func assign_sync_properties(rep_config: SceneReplicationConfig) -> void:
    rep_config.add_property(^".:position")
    rep_config.add_property(^".:rotation")
    rep_config.add_property(^".:scale")

func _enter_tree() -> void:
    if pid:
        set_multiplayer_authority(pid)

func _ready() -> void:
    #NetworkManager.do_print("entity is spawned %s" % pid)
    
    for component: Component in components:
        component._post_ready()

func register_component(component: Component) -> void:
    components.append(component)
    
func find_component_of_type(type: GDScript) -> Component:
    return components[_get_component_idx_of_type(type)]

func has_component_of_type(type: GDScript) -> bool:
    return !!_get_component_idx_of_type(type)

func _get_component_idx_of_type(type: GDScript) -> int:
    return components.find_custom(func(component: Component) -> bool: return component.get_script() == type)
