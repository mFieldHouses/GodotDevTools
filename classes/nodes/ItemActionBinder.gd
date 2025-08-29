extends Node
class_name ItemActionBinder

@export var item_action_bindings_resource : ItemActionBindings:
	set(x):
		item_action_bindings_resource = x
		item_action_bindings = x.item_action_bindings
		x.changed.connect(func update_bindings(): item_action_bindings = x.item_action_bindings; print("update bindings"))
		
var item_action_bindings : Array :
	set(x):
		item_action_bindings = x
		#print(item_action_bindings)
		
		oneshot_bindings = []
		for binding in x:
			if binding.oneshot:
				oneshot_bindings.append(false)
			else:
				oneshot_bindings.append(null)

var parent : Node

var oneshot_bindings : Array = [] ##True or false indicates that the binding at that index is a oneshot action. A <null> value indicates it isn't. When the binding is a oneshot binding, true indicates it was pressed previous frame and false indicates it wasn't.

var mouse_scroll_buffer : Array = []

func _ready() -> void:
	parent = get_parent()

func _process(delta: float) -> void:
	var binding_idx : int = 0
	
	for binding : Dictionary in item_action_bindings:
		#print(binding_idx)
		var binding_triggered : int = is_binding_triggered(binding)
		
		#print(binding.oneshot)
		if binding.oneshot and !binding_triggered:
				oneshot_bindings[binding_idx] = false
		
		if binding.oneshot:
			binding_triggered = binding_triggered && !oneshot_bindings[binding_idx]
		
		if !binding_triggered:
			#print("not triggered")
			binding_idx += 1
			continue
		
		#print("triggered")
		
		oneshot_bindings[binding_idx] = true
		
		if binding.has("property_num"):
			match binding.property_num.mode:
				"change_add":
					parent.set(binding.target_name, parent.get(binding.target_name) + binding.property_num.value)
				"change_mult":
					parent.set(binding.target_name, parent.get(binding.target_name) * binding.property_num.value)
				"set":
					parent.set(binding.target_name, binding.property_num.value)
		
		if binding.has("property_bool"):
			match binding.property_num.mode:
				"toggle":
					parent.set(binding.target_name, !parent.get(binding.target_name))
				"set":
					parent.set(binding.target_name, binding.property_num.value)
		
		if binding.has("property_string"):
			match binding.property_string.mode:
				"set":
					parent.set(binding.target_name, binding.property_string.value)
				"append":
					parent.set(binding.target_name, parent.get(binding.target_name).join(PackedStringArray([binding.property_string.value])))
				"prepend":
					parent.set(binding.target_name, binding.property_string.value.join(PackedStringArray([parent.get(binding.target_name)])))
				"popf":
					parent.set(binding.target_name, parent.get(binding.target_name).lstrip(parent.get(binding.target_name).left(1)))
				"popb":
					parent.set(binding.target_name, parent.get(binding.target_name).rstrip(parent.get(binding.target_name).reft(1)))
		
		if binding.has("callable"):
			parent.call(binding.callable.name)
		
		binding_idx += 1
		
func is_binding_triggered(binding) -> bool:
	var result : int = 1
	
	for key in binding.keys:
		if !Input.is_key_pressed(key):
			result = 0
		
	for mouse_button in binding.mouse_buttons:
		if (mouse_button == MOUSE_BUTTON_WHEEL_UP or mouse_button == MOUSE_BUTTON_WHEEL_DOWN) and mouse_scroll_buffer.has(mouse_button) and result != 0:
			result = mouse_scroll_buffer.count(mouse_button)
		elif mouse_button != MOUSE_BUTTON_WHEEL_UP and mouse_button != MOUSE_BUTTON_WHEEL_DOWN and result != 0 and Input.is_mouse_button_pressed(mouse_button):
			result = 1
		else:
			result = 0
		#print("i am ", mouse_button, " and triggered = ", result)
		mouse_scroll_buffer.erase(mouse_button)
	
	return result
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		mouse_scroll_buffer.append(event.button_index)
		#print("set scroll buffer to ", mouse_scroll_buffer)
