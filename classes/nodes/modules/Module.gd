@icon("res://addons/shadowstrider_dev/module.svg")
extends Node3D
class_name Module

##Base class for modular classes used in Shadowstrider development.

func get_triggers() -> Array[Trigger]:
	var result : Array[Trigger] = []
	
	for child in get_children():
		if child is Trigger:
			result.append(child)
	
	return result


func no_triggers_error():
	printerr(self, " does not have any Triggers as children and will not be interactable.")


func no_enabled_triggers_error():
	printerr(self, " does not have any enabled Triggers as children and will not be interactable.")


func get_area_3ds() -> Array[Area3D]:
	var result : Array[Area3D] = []
	
	for child in get_children():
		if child is Area3D:
			result.append(child)
	
	return result
