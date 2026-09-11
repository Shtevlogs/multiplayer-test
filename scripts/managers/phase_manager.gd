extends Node

@onready var phase_view: TextureRect = $"/root/Main/CanvasLayer/PhaseView"
@onready var phase_spawner: PhaseSpawner = $"/root/Main/Managers/PhaseSpawner"
@onready var phases: Array[SubViewport] = [
    $"/root/Main/SceneRoot/SubViewportContainer/Phase0",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase1",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase2",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase3",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase4",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase5",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase6",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase7",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase8",
    $"/root/Main/SceneRoot/SubViewportContainer/Phase9"
]
var scene_assignments: Array[int] = [
    -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1
]

var phase_views: Array[ViewportTexture] = [ ]

var phase_count := 10
#TODO: figure out how to create more phases as needed?

func _ready() -> void:
    for i: int in phases.size():
        var phase := phases[i]
        phase_views.append(phase.get_texture())
        phase.get_node('PlayerSpawner').phase = i
        phase.get_node('SceneSpawner').phase = i
    phase_view.texture = phase_views[0]

func get_player_spawner(phase: int) -> PlayerSpawner:
    return phases[phase].get_node("PlayerSpawner")
    
func get_scene_spawner(phase: int) -> SceneSpawner:
    return phases[phase].get_node("SceneSpawner")

func get_scene_phase(scene_no: int) -> int:
    for i: int in scene_assignments.size():
        var assignment := scene_assignments[i]
        if assignment == scene_no:
            return i
    return -1

func reserve_unused_phase(scene_no: int) -> int:
    for i: int in scene_assignments.size():
        var assignment := scene_assignments[i]
        if assignment == -1:
            scene_assignments[i] = scene_no
            return i
    return -1

func is_phase_open(phase: int, to_scene: int) -> bool:
    return scene_assignments[phase] == to_scene

func update_view(phase: int) -> void:
    phase_view.texture = phase_views[phase]
