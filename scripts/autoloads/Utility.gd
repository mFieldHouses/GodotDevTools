extends Node

var debug_material : StandardMaterial3D = load("res://addons/shadowstrider_dev/resources/materials/debug_mat.tres")

func int_to_bin(x : int, byte_length : int) -> Array: ##Returns an array of bits representing the value of x converted to binary in big-endian
	var output = []
	output.resize(4)
	output.fill(0)
	
	if x == 0:
		return output
	
	var idx = 0
	while x > 0:
		output[idx] = x % 2
		x /= 2
		idx += 1
	
	return output

func ints_to_bitmask(ints : Array[int]):
	pass

func get_action_key(action_name : StringName):
	return OS.get_keycode_string(InputMap.action_get_events(action_name)[0].physical_keycode)

func visualise_point(point : Vector3, root_node_3d : Node3D, delay_time : float = -1.0):
	var new_visualiser_mesh = BoxMesh.new()
	new_visualiser_mesh.size = Vector3(0.2, 2.0, 0.2)
	new_visualiser_mesh.material = debug_material
	
	var new_mesh_instance = MeshInstance3D.new()
	new_mesh_instance.mesh = new_visualiser_mesh
	
	root_node_3d.add_child(new_mesh_instance)
	new_mesh_instance.position = point
	
	if delay_time != -1.0:
		await get_tree().create_timer(delay_time).timeout
		new_mesh_instance.queue_free()
