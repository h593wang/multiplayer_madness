extends Node2D

const world_scene = preload('res://common/world/world.tscn')
var world = null

var players = {}

func on_peer_connected(id):
	print("Peer %d connected!\n" % id)
	var player = world.add_player(id)
	players[id] = player
	
func on_peer_disconnected(id):
	print("Peer %d disconnected!\n" % id)
	world.destroy_player(id)

# Called when the node enters the scene tree for the first time.
func _ready():
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(Globals.MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(on_peer_connected)	
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
	world = world_scene.instantiate()
	get_tree().root.call_deferred('add_child', world)

func _process(_delta):
	pass
