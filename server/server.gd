extends Node2D

const Constants = preload("res://common/globals.gd")

func on_peer_connected(id):
	print("Peer %d connected!\n" % id)

# Called when the node enters the scene tree for the first time.
func _ready():
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(Constants.MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(on_peer_connected)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
