class_name Phaseable
extends Node2D

signal on_entered_phase(p:int)

@export var phase := -1

func _init() -> void:
    tree_entered.connect(_check_phase)

func _check_phase() -> void:
    if phase == -1: return
    var parent := get_parent()
    if parent && parent is SubViewport:
        on_entered_phase.emit(phase)

@rpc('any_peer', 'call_local')
func change_phase(new_phase: int) -> void:
    if !is_multiplayer_authority(): return
    if new_phase == phase: return
    
    # had to do this because of circ reference?
    # TODO: make it so that doesn't happen ...ffs
    $/root/PlayerManager.call_deferred(&"request_spawn_self", new_phase)
    $/root/PhaseManager.update_view(new_phase)
    
    await get_tree().process_frame
    
    queue_free()
    
