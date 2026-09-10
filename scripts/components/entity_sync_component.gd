class_name EntitySyncComponent
extends Component

var synchronizer : MultiplayerSynchronizer = self as Variant

func _enter_tree() -> void:
    if !synchronizer.replication_config.has_property(^".:position"):
        assign_sync_properties()
        pass

func assign_sync_properties() -> void:
    get_parent().assign_sync_properties(synchronizer.replication_config)
