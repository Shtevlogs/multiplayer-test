class_name CharacterBodyEntity
extends Entity

static var _character_body_entity_rep_config : SceneReplicationConfig = SceneReplicationConfig.new()

var body : CharacterBody2D = self as Variant

func _physics_process(_delta: float) -> void:
    if !is_multiplayer_authority(): return
    body.move_and_slide()

func get_rep_config() -> SceneReplicationConfig:
    return _character_body_entity_rep_config

func assign_sync_properties(rep_config: SceneReplicationConfig) -> void:
    super.assign_sync_properties(rep_config)
    rep_config.add_property(^".:velocity")
