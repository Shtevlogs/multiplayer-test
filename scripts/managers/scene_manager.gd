extends Node

const WORLD := 0
const WORLD_2 := 1
const TILE_WORLD := 2
const RANDOM_TILE_WORLD := 3

const SCENES : Array[PackedScene] = [
    preload("uid://xgbtjip1bena"), # World
    preload("uid://8mpmo88pirew"), # World 2
    preload("uid://b52odx0msno33"), # Tileworld
    preload("uid://dlmxpem7jrhq1") # Random Tileworld
]

func request_scene(scene_no: int) -> int:
    var scene_spawners := PhaseManager.get_spawners(SceneSpawner)
    var scene_spawner_idx := scene_spawners.find_custom(
        func(spawner: SceneSpawner) -> bool:
            return spawner.spawned_scene_no == scene_no
            )
    
    var scene_spawner := null if scene_spawner_idx == -1 else scene_spawners[scene_spawner_idx]
    
    # check for unassigned phases
    if !scene_spawner:
        scene_spawner_idx = scene_spawners.find_custom(
        func(spawner: SceneSpawner) -> bool:
            return spawner.spawned_scene_no == -1
            )
        scene_spawner = null if scene_spawner_idx == -1 else scene_spawners[scene_spawner_idx]
    
    if scene_spawner:
        spawn_scene(scene_no, scene_spawner)
        return scene_spawner.phase
    
    var phase_no := await PhaseManager.create_new_phase()
    var phase : Phase = PhaseManager.get_phase(phase_no)
    spawn_scene(scene_no, phase.get_spawner(SceneSpawner))
    return phase.get_number()

func spawn_scene(scene_no: int, scene_spawner: SceneSpawner) -> void:
    if !multiplayer.is_server(): return
    
    if scene_spawner.is_scene_active(scene_no):
        return
    
    await get_tree().process_frame
    scene_spawner.spawn(scene_no)
    
