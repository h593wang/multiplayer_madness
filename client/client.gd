extends Node2D


var world_scene = preload('res://common/world/world.tscn')
var world = null

var client_peer: WebSocketMultiplayerPeer = null

func on_client_peer_connected(_peer_id):
	Globals.client_peer_id = client_peer.get_unique_id()

# Called when the node enters the scene tree for the first time.
func _ready():
	client_peer = WebSocketMultiplayerPeer.new()
	var url = Globals.server_host + ':' + str(Globals.server_port)
	client_peer.peer_connected.connect(on_client_peer_connected)
	client_peer.create_client(url, TLSOptions.client_unsafe())
	multiplayer.multiplayer_peer = client_peer
	
	world = world_scene.instantiate()
	get_tree().root.call_deferred('add_child', world)
	
func _process(_delta):
	client_peer.poll()
	
