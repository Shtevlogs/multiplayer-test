class_name PlayerMultiplayerSynchronizer
extends MultiplayerSynchronizer

func _enter_tree() -> void:
    NetworkManager.I.do_print('player entered scene %s' % get_parent().pid)
    set_multiplayer_authority(get_parent().pid)
