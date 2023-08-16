extends Node2D

@onready var player_node = $players
const Player = preload("res://client/player.tscn")

func add_player(peer_id):
	var p = Player.instantiate() as Player
	p.global_position = Vector2(randi() % 500, randi() % 500)
	p.name = str(peer_id)
	player_node.add_child(p, true)
	
	return p

func destroy_player(peer_id):
	player_node.get_node(str(peer_id)).queue_free()
