class_name MMWorld extends Node2D

@onready var player_node = $players
const Player = preload("res://client/player.tscn")

@export var enemies_killed: int
var players = {}

var rng = RandomNumberGenerator.new()

func _process(delta):
	if Globals.is_server():
		enemies_killed = Globals.enemies_killed
	else:
		Globals.enemies_killed = enemies_killed	
		
	$UI/Health.text = "Health: " + str(Globals.current_player_health) + "/3"
	$UI/Enemies_killed.text = "Enemies Killed: " + str(Globals.enemies_killed)

func add_player(peer_id):
	var p = Player.instantiate() as Player
	p.global_position = Vector2(randi() % 500, randi() % 500)
	p.name = str(peer_id)
	p.health = 3
	p.dead = false
	p.is_invincible = false
	player_node.add_child(p, true)
	
	players[peer_id] = p

	return p

func destroy_player(peer_id):
	player_node.get_node(str(peer_id)).queue_free()
	players.erase(peer_id)
	
func get_visible_bounds():
	pass

func _ready():
	pass
