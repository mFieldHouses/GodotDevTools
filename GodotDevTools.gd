@tool
extends EditorPlugin

var parameters_plugin

var previous_item_action_binding_property_list

func _enter_tree() -> void:
	pass
	#add_autoload_singleton("Utility", "res://addons/GodotDevTools/scripts/autoloads/Utility.gd")
	#add_autoload_singleton("GameLogger", "res://addons/GodotDevTools/scripts/autoloads/GameLogger.gd")


func _process(delta: float) -> void:
	var edited_object = EditorInterface.get_inspector().get_edited_object()
	if edited_object is ItemModelPropertyBindings:
		var property_value_list = []
		for property in edited_object.get_property_list():
			property_value_list.append(edited_object.get(property.name))
		
		if previous_item_action_binding_property_list:
			if previous_item_action_binding_property_list != property_value_list:
				edited_object.emit_changed()
		
		previous_item_action_binding_property_list = property_value_list

func _exit_tree() -> void:
	pass
