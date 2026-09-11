class_name Phaseable
extends Node2D

@export var phase := -1

@rpc('any_peer', 'call_local')
func cleanup() -> void:
    set_multiplayer_authority(1)
    if is_multiplayer_authority():
        await get_tree().process_frame
        queue_free()
