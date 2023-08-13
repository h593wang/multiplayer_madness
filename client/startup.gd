extends Node2D

func was_started_with_server():
	return '--server' in OS.get_cmdline_user_args()

# Called when the node enters the scene tree for the first time.
func _ready():
	if was_started_with_server():
		get_tree().change_scene_to_file('res://server/server.tscn')
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client("1.proxy.hathora.dev", 41487)
	multiplayer.multiplayer_peer = client_peer
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
