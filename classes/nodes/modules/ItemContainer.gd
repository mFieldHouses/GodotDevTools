extends Module
class_name ItemContainer

##Module that keeps track of an ordered volume of items.

var items : Array = [load("res://assets/resources/items/henk.tres"), load("res://assets/resources/items/henk.tres"), load("res://assets/resources/items/henk.tres")]

func get_parent_object_position() -> Vector3:
	return get_parent().position
