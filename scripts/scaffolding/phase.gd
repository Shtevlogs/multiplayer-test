class_name Phase
extends SubViewport

const STALE_TIME := 3.0

@onready var player_spawner: PlayerSpawner = $PlayerSpawner
@onready var scene_spawner: SceneSpawner = $SceneSpawner

signal stale()

var empty_time := 0.0
@export var scene_assignment := -1

@export var _phase := -1

func _process(delta: float) -> void:
    if get_child_count() <= 3:
        empty_time += delta
    else:
        empty_time = 0.0
    if empty_time > STALE_TIME:
        stale.emit()

func get_number() -> int:
    return _phase
