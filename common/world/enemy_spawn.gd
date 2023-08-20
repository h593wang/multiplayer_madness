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
	if !Globals.is_server() or world.players.is_empty():
		return
	if Globals.enemies_killed >= 100 && !Globals.boss_spawned:
		var boss = enemy_scene.instantiate()
		boss.position = get_spawn_position()
		boss.is_boss = true
		boss.world = world
		call_deferred('add_child', boss, true)
		Globals.boss_spawned = true
		return
	if Globals.boss_spawned:
		return
	# Do fancy spawn tables or whatever later.
	var enemy = enemy_scene.instantiate()
	enemy.position = get_spawn_position()
	enemy.world = world
	call_deferred('add_child', enemy, true)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.wait_time = ENEMY_SPAWN_INTERVAL_S / max(1, len(world.players.values()))
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	spawn_timer.start()
