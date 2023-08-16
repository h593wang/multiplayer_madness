extends Node2D

var client_peer: ENetMultiplayerPeer

var world_scene = preload('res://common/world.tscn')
var world = null

# Called when the node enters the scene tree for the first time.
func _ready():
	client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(Globals.server_host, Globals.server_port)
	multiplayer.multiplayer_peer = client_peer
	
	world = world_scene.instantiate()
	get_tree().root.call_deferred('add_child', world)
