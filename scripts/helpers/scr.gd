class_name SCR
extends Node

static var path_cache : Dictionary[StringName, GDScript]

static func get_cached_script(path: StringName) -> GDScript:
    if !path_cache.has(path):
        path_cache[path] = load(path)
    return path_cache[path]
