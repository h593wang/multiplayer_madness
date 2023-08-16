extends Node2D

const server_scene = preload('res://server/server.tscn')
const client_scene = preload('res://client/lobby.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.is_server():
		get_tree().root.call_deferred('add_child', server_scene.instantiate())
	else:
		get_tree().root.call_deferred('add_child', client_scene.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
