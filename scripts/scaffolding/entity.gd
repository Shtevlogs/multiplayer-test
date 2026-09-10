class_name Entity
extends Node2D

@export var pid : int

var components : Array[Component] = []

func _init() -> void:
    var entity_sync := MultiplayerSynchronizer.new()
    entity_sync.replication_config = SceneReplicationConfig.new()
    entity_sync.set_script(EntitySyncComponent)
    add_child(entity_sync)

func _enter_tree() -> void:
    set_multiplayer_authority(pid)

func _ready() -> void:
    NetworkManager.I.do_print("entity is spawned %s" % pid)
    if !is_multiplayer_authority(): return

    for component: Component in components:
        component._post_ready()

func register_component(component: Component) -> void:
    components.append(component)

func find_component_of_type(type: GDScript) -> Component:
    return components[_get_component_idx_of_type(type)]

func _get_component_idx_of_type(type: GDScript) -> int:
    return components.find_custom(func(component: Component) -> bool: return component.get_script() == type)
