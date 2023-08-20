extends Node2D

const world_scene = preload('res://common/world/world.tscn')
var world = null

var players = {}

var players_joined = false

var server_peer: WebSocketMultiplayerPeer = null

func on_peer_connected(id):
	print("Peer %d connected!\n" % id)
	var player = world.add_player(id)
	players[id] = player
	
	players_joined = true
	
func on_peer_disconnected(id):
	print("Peer %d disconnected!\n" % id)
	world.destroy_player(id)

	players.erase(id)
	
	if players.size() == 0 and players_joined:
		server_peer.close()

# Called when the node enters the scene tree for the first time.
func _ready():
	server_peer = WebSocketMultiplayerPeer.new()
	server_peer.create_server(Globals.MULTIPLAYER_PORT)
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(on_peer_connected)	
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
	world = world_scene.instantiate()
	get_tree().root.call_deferred('add_child', world)

func _process(_delta):
	server_peer.poll()
