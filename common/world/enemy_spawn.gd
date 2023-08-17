extends Node

@export var world: MMWorld

@onready var spawn_timer = $spawn_timer

const enemy_scene = preload('res://enemy/Enemy.tscn')

var rng = RandomNumberGenerator.new()

const ENEMY_SPAWN_INTERVAL_S = 5

const ENEMY_SPAWN_DIST_MIN = 500
const ENEMY_SPAWN_DIST_MAX = 1000

func get_random_player_position():
	var n = len(world.players.values())
	var i = rng.randi_range(0, n - 1)
	
	return world.players.values()[i].global_position

func get_spawn_position():
	var target_position = get_random_player_position()
	var dist = rng.randi_range(ENEMY_SPAWN_DIST_MIN, ENEMY_SPAWN_DIST_MAX)
	var angle = deg_to_rad(rng.randi_range(0, 360))
	
	var offset = Vector2(cos(angle), sin(angle)) * dist
	
	return target_position + offset

func on_spawn_timer_timeout():
	if !Globals.is_server():
		return
	# Do fancy spawn tables or whatever later.
	var enemy = enemy_scene.instantiate()
	enemy.position = get_spawn_position()
	enemy.world = world
	call_deferred('add_child', enemy, true)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.wait_time = ENEMY_SPAWN_INTERVAL_S
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	spawn_timer.start()
