class_name EntitySyncComponent
extends Component

var synchronizer : MultiplayerSynchronizer = self as Variant

func _enter_tree() -> void:
    if !synchronizer.replication_config.has_property(^".:position"):
        assign_sync_properties()
        pass

func assign_sync_properties() -> void:
    synchronizer.replication_config.add_property(^".:position")
    synchronizer.replication_config.add_property(^".:rotation")
    synchronizer.replication_config.add_property(^".:scale")
    # And whatever else we need for an Entity
