class_name MMWorld extends Node2D

@onready var player_node = $players
const Player = preload("res://player/player.tscn")
@onready var heart_filled = preload("res://resources/health1.png")
@onready var heart_empty = preload("res://resources/health2.png")

@export var enemies_killed: int
var players = {}
@onready var bgm_player = $bgm_player

var rng = RandomNumberGenerator.new()

func _process(_delta):
	if Globals.is_server():
		enemies_killed = Globals.enemies_killed
	else:
		Globals.enemies_killed = enemies_killed	
	
	if Globals.current_player_health > 0:
		$UI.visible = true
		if Globals.current_player_health == 3:
			$UI/HealthRow/Heart1.texture = heart_filled
			$UI/HealthRow/Heart2.texture = heart_filled
			$UI/HealthRow/Heart3.texture = heart_filled
		elif Globals.current_player_health == 2:
			$UI/HealthRow/Heart1.texture = heart_filled
			$UI/HealthRow/Heart2.texture = heart_filled
			$UI/HealthRow/Heart3.texture = heart_empty
		elif Globals.current_player_health == 1:
			$UI/HealthRow/Heart1.texture = heart_filled
			$UI/HealthRow/Heart2.texture = heart_empty
			$UI/HealthRow/Heart3.texture = heart_empty
		else:
			$UI/HealthRow/Heart1.texture = heart_empty
			$UI/HealthRow/Heart2.texture = heart_empty
			$UI/HealthRow/Heart3.texture = heart_empty
		$UI/Enemies_killed.text = "Enemies Killed: " + str(Globals.enemies_killed)
	else:
		$UI.visible = false

func add_player(peer_id):
	var p = Player.instantiate() as Player
	p.global_position = Vector2(randi() % 500, randi() % 500)
	p.name = str(peer_id)
	p.health = 3
	p.dead = false
	p.is_invincible = false
	player_node.add_child(p, true)
	
	players[peer_id] = p
	Globals.player_count = len(players)

	return p

func destroy_player(peer_id):
	player_node.get_node(str(peer_id)).queue_free()
	players.erase(peer_id)
	
func get_visible_bounds():
	pass

func _ready():
	Globals.player_dead.connect(queue_free)
	# No need to play music on the server
	if Globals.is_server():
		bgm_player.playing = false

