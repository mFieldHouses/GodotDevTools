extends Node

var verbose : bool = false

func toggle_verbose(state : bool = true):
	verbose = state
	GameConsole.print_line("Set GameLogger.verbose to " + str(state))

func print_as_script(script_owner : Node, message : String) -> void:
	print("<" + script_owner.get_script().get_path() + "> - " + message)

func printerr_as_script(script_owner : Node, message : String) -> void:
	printerr("<" + script_owner.get_script().get_path() + "> - " + message)

func print_verbose_as_script(script_owner : Node, message : String) -> void:
	if verbose:
		print("V <" + script_owner.get_script().get_path() + "> - ", message)

func print_verbose_as_autoload(autoload_instance : Node, message : String) -> void:
	if verbose:
		print("V [" + autoload_instance.name + "] - ", message)

func print_as_autoload(autoload_instance : Node, message : String) -> void:
	print("[" + autoload_instance.name + "] - ", message)

func printerr_as_autoload(autoload_instance : Node, error : String) -> void:
	#print.callv(["[" + autoload_instance.name + "] - ", errors])
	printerr("[" + autoload_instance.name + "] - ", error)
