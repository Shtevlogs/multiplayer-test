class_name Phase
extends SubViewport

const STALE_TIME := 3.0

static var empty_cutoff := 0

signal stale()

@export var spawner_scripts : Array[GDScript] = []
@export var _phase := -1

var empty_time := 0.0
var spawners: Array[PhaseAwareSpawner] = []

func _ready() -> void:
    for s: GDScript in spawner_scripts:
        var new_spawner : PhaseAwareSpawner = s.new()
        new_spawner.spawn_path = ".."
        new_spawner.phase = _phase
        add_child(new_spawner, false, InternalMode.INTERNAL_MODE_BACK)
        spawners.append(new_spawner)
    
    var multiplayer_synchronizer := MultiplayerSynchronizer.new()
    var replication_config := SceneReplicationConfig.new()
    replication_config.add_property(^".:_phase")
    multiplayer_synchronizer.replication_config = replication_config
    add_child(multiplayer_synchronizer, false, InternalMode.INTERNAL_MODE_BACK)

func get_spawner(spawn_script: GDScript) -> PhaseAwareSpawner:
    var idx := spawner_scripts.find(spawn_script)
    if idx == -1: return null
    return spawners[idx]

func _process(delta: float) -> void:
    if get_child_count() <= empty_cutoff:
        empty_time += delta
    else:
        empty_time = 0.0
    if empty_time > STALE_TIME:
        stale.emit()

func get_number() -> int:
    return _phase
