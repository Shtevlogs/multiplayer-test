class_name PathWalkerComponent
extends OwnerComponent

@onready var path_2d: Path2D = $Path2D

var body_mover_component : BodyMoverComponent

var _start : Vector2 = Vector2.ZERO
var _backwards := false

func _post_ready() -> void:
    body_mover_component = parent.find_component_of_type(BodyMoverComponent)
    _start = parent.global_position

    var starting_point := path_2d.curve.get_point_position(0)
    if starting_point != Vector2.ZERO:
        path_2d.curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, 0)

func _physics_process(delta: float) -> void:
    var curve := path_2d.curve
    var location := parent.global_position - _start
    var current_progress := curve.get_closest_offset(location)
    var leng := curve.get_baked_length()
    var forward_progress := minf(current_progress + curve.bake_interval * (1.0 if !_backwards else -1.0), leng)
    if forward_progress >= leng || forward_progress <= 0:
        _backwards = !_backwards
    var next_path_pos := curve.sample_baked(forward_progress)
    var forward := Vector2.UP.rotated(Vector2.UP.angle_to(next_path_pos - location))
    body_mover_component._on_joystick(forward, delta)
