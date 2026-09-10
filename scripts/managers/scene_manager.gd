class_name SceneManager
extends Node

const WORLD := 0

const SCENES : Array[PackedScene] = [
    preload("uid://xgbtjip1bena") # World
]

static var I : SceneManager

@onready var scene_root: Node2D = $"../../SceneRoot"
@onready var scene_spawner: SceneSpawner = $"../SceneSpawner"

func _ready() -> void:
    I = self

func change_scene(scene_no: int) -> void:
    if !multiplayer.is_server(): return
    for node : Node in scene_root.get_children():
        node.queue_free()
    
    scene_spawner.spawn(scene_no)
