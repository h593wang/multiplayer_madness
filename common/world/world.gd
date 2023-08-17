class_name MMWorld extends Node2D

@onready var player_node = $players
const Player = preload("res://player/player.tscn")

var players = {}

var rng = RandomNumberGenerator.new()

@onready var bgm_player = $bgm_player

func add_player(peer_id):
	var p = Player.instantiate() as Player
	p.global_position = Vector2(randi() % 500, randi() % 500)
	p.name = str(peer_id)
	player_node.add_child(p, true)
	
	players[peer_id] = p

	return p

func destroy_player(peer_id):
	player_node.get_node(str(peer_id)).queue_free()
	players.erase(peer_id)
	
func get_visible_bounds():
	pass

func _ready():
	# No need to play music on the server
	if Globals.is_server():
		bgm_player.playing = false
