extends Node2D

var client_peer: ENetMultiplayerPeer

# Called when the node enters the scene tree for the first time.
func _ready():
	client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(Globals.server_host, Globals.server_port)
	multiplayer.multiplayer_peer = client_peer

func _process(delta):
	pass
