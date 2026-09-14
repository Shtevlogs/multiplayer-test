class_name TileMapLayerEntity
extends Entity

static var _tile_map_layer_entity_rep_config : SceneReplicationConfig = SceneReplicationConfig.new()

var tile_map : TileMapLayer = self as Variant

func get_rep_config() -> SceneReplicationConfig:
    return _tile_map_layer_entity_rep_config

func assign_sync_properties(rep_config: SceneReplicationConfig) -> void:
    super.assign_sync_properties(rep_config)
    rep_config.add_property(^".:tile_map_data")
