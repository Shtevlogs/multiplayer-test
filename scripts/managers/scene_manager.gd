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

static var SCENE_MOCKS : Array[Phaseable] = []

func request_scene(scene_no: int) -> int:
    var phase := PhaseManager.get_scene_phase(scene_no)
    if phase >= 0:
        spawn_scene(scene_no, phase)
        return phase
    else:
        phase = await PhaseManager.reserve_unused_phase(scene_no)
    spawn_scene(scene_no, phase)
    return phase

func spawn_scene(scene_no: int, phase: int) -> void:
    if !multiplayer.is_server(): return
    
    if !PhaseManager.is_phase_open(phase, scene_no):
        push_error("couldn't spawn scene %s, phase %s already in use!" % [scene_no, phase])
        return
    
    var scene_spawner := PhaseManager.get_scene_spawner(phase)
    
    if scene_spawner.is_scene_active(scene_no):
        return
    
    await get_tree().process_frame
    scene_spawner.spawn(scene_no)
    
