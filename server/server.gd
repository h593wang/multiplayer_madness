extends Node2D

const Player = preload("res://client/player.tscn")
const Constants = preload("res://common/globals.gd")

func on_peer_connected(id):
	print("Peer %d connected!\n" % id)
	create_player(id)
	
func on_peer_disconnected(id):
	print("Peer %d disconnected!\n" % id)
	destroy_player(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(Constants.MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(on_peer_connected)	
	multiplayer.peer_disconnected.connect(on_peer_disconnected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_player(id):
	# Instantiate a new player for this client.
	var p = Player.instantiate() as Player
	# Set a random position (sent on every replicator update).
	p.global_position = Vector2(randi() % 500, randi() % 500)
	# Add it to the "Players" node.
	# We give the new Node a name for easy retrieval, but that's not necessary.
	p.name = str(id)
	get_node("/root/MainScene/Network").add_child(p)
	
func destroy_player(id):
	# Delete this peer's node.
	get_node("/root/MainScene/Network").get_node(str(id)).queue_free()
