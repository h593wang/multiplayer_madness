extends Node2D

var client_peer: ENetMultiplayerPeer
const server = preload('res://server/server.tscn')

func was_started_with_server():
	return '--server' in OS.get_cmdline_user_args()

# Called when the node enters the scene tree for the first time.
func _ready():
	if was_started_with_server():
		get_tree().root.call_deferred("add_child", server.instantiate())
	else:
		client_peer = ENetMultiplayerPeer.new()
		client_peer.create_client("1.proxy.hathora.dev", 61461)
		multiplayer.multiplayer_peer = client_peer
