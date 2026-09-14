class_name InputComponent
extends OwnerComponent

var _pressed : Array[StringName] = []
var _just_pressed : Array[StringName] = []
var _just_released : Array[StringName] = []
var _has_on_joystick : bool

func _post_ready() -> void:
    for component: Component in parent.components:
        if component == self: return # don't need this one
        register_events(component)
            
func register_events(component: Component) -> void:
    var script : GDScript = component.get_script()
    
    var methods := script.get_script_method_list()
    
    var names : Array[String] = []
    for method : Dictionary in methods:
        names.append(method['name'])
        
    for action_name : StringName in InputMap.get_actions():
        var pressed := '_on_%s_pressed' % action_name
        var just_pressed := '_on_%s_just_pressed' % action_name
        var just_released := '_on_%s_just_released' % action_name
        if names.has(pressed):
            if !has_user_signal(pressed):
                add_user_signal(pressed)
            connect(pressed, _create_signal_call(pressed,component))
            _pressed.append(pressed)
        if names.has(just_pressed):
            if !has_user_signal(just_pressed):
                add_user_signal(just_pressed)
            connect(just_pressed, _create_signal_call(just_pressed,component))
            _just_pressed.append(just_pressed)
        if names.has(just_released):
            if !has_user_signal(just_released):
                add_user_signal(just_released)
            connect(just_released, _create_signal_call(just_released,component))
            _just_released.append(just_released)
    
    if names.has(&'_on_joystick'):
        if !_has_on_joystick:
            add_user_signal(&'_on_joystick')
        connect(&'_on_joystick', (func(v: Vector2, d: float, c: Component):
            if !c || c.is_queued_for_deletion(): return 
            c.call(&'_on_joystick', v, d)).bind(component))
        _has_on_joystick = true
        
func _create_signal_call(method_name : StringName, component: Component):
    return (func(c: Component, m_n: StringName): c.call(m_n)).bind(component, method_name)

func _physics_process(delta: float) -> void:
    for action_name:StringName in _pressed:
        if Input.is_action_pressed(action_name):
            emit_signal('_on_%s_pressed' % action_name)
    for action_name:StringName in _just_pressed:
        if Input.is_action_just_pressed(action_name):
            emit_signal('_on_%s_just_pressed' % action_name)
    for action_name:StringName in _just_released:
        if Input.is_action_just_released(action_name):
            emit_signal('_on_%s_just_released' % action_name)

    if _has_on_joystick:
        emit_signal(&'_on_joystick', Input.get_vector(&'a',&'d',&'w',&'s'), delta)
