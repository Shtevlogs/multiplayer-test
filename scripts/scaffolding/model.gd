@abstract
class_name Model

const MODEL_TYPE := &"_model_type"

static func from_dict(dict: Dictionary) -> Model:
    var model : Model = create_model(dict)
    model._apply_dict(dict)
    return model

static func create_model(dict: Dictionary) -> Model:
    var model_path : StringName = dict[MODEL_TYPE]
    var model_script : GDScript = SCR.get_cached_script(model_path)
    return model_script.new()

func as_dict() -> Dictionary:
    var dict := {
        MODEL_TYPE: get_script().get_path()
    }

    var properties : Array[Dictionary] = get_property_list()
    for property : Dictionary in properties:
        #- name is the property's name, as a String;
        var p_name := property["name"] as String
        if filter_p_name(p_name): continue
        #- class_name is an empty StringName, unless the property is TYPE_OBJECT and it inherits from a class;
        @warning_ignore('unused_variable')
        var p_class_name := property["class_name"] as StringName
        #TODO: grab class and try to serialize?
        #- type is the property's type, as an int (see Variant.Type);
        @warning_ignore('unused_variable')
        var p_type := property["type"] as Variant.Type
        #TODO: find type serialization code from MotionDungeon?
        #- hint is how the property is meant to be edited (see PropertyHint);
        @warning_ignore('unused_variable')
        var p_hint := property["hint"] as PropertyHint
        #- hint_string depends on the hint (see PropertyHint);
        @warning_ignore('unused_variable')
        var p_hint_string := property["hint_string"] as String
        #- usage is a combination of PropertyUsageFlags.
        @warning_ignore('unused_variable')
        var usage := property["usage"] as int

        # for now we'll just be dumb
        dict[p_name] = get(p_name)

    return dict

func _apply_dict(dict: Dictionary) -> void:
    var properties : Array[Dictionary] = get_property_list()
    for property : Dictionary in properties:
        #- name is the property's name, as a String;
        var p_name := property["name"] as String
        if filter_p_name(p_name) || !dict.has(p_name): continue
        #- class_name is an empty StringName, unless the property is TYPE_OBJECT and it inherits from a class;
        @warning_ignore('unused_variable')
        var p_class_name := property["class_name"] as StringName
        #TODO: grab class and try to serialize?
        #- type is the property's type, as an int (see Variant.Type);
        @warning_ignore('unused_variable')
        var p_type := property["type"] as Variant.Type
        #TODO: find type serialization code from MotionDungeon?
        #- hint is how the property is meant to be edited (see PropertyHint);
        @warning_ignore('unused_variable')
        var p_hint := property["hint"] as PropertyHint
        #- hint_string depends on the hint (see PropertyHint);
        @warning_ignore('unused_variable')
        var p_hint_string := property["hint_string"] as String
        #- usage is a combination of PropertyUsageFlags.
        @warning_ignore('unused_variable')
        var usage := property["usage"] as int

        # for now we'll just be dumb
        set(p_name, dict[p_name]) #TODO: make a generic type conversion function

func filter_p_name(p_name: String) -> bool:
    return p_name.begins_with("_") || p_name == "db"
