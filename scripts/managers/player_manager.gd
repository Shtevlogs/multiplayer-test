class_name PlayerManager
extends Node

static var I : PlayerManager

@onready var player_spawner: PlayerSpawner = $"../PlayerSpawner"

func _ready() -> void:
    I = self

func spawn_self() -> void:
    player_spawner.spawn(multiplayer.get_unique_id())
