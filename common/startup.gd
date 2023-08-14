extends Node2D

const server = preload('res://server/server.tscn')

func was_started_with_server():
	return '--server' in OS.get_cmdline_user_args()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if was_started_with_server():
		get_tree().change_scene_to_file("res://server/server.tscn")
	else:
		get_tree().change_scene_to_file("res://client/lobby.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
