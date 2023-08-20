extends Node

@export var world: MMWorld

@onready var spawn_timer = $spawn_timer

const enemy_scene = preload('res://enemy/Enemy.tscn')

var rng = RandomNumberGenerator.new()

const ENEMY_SPAWN_INTERVAL_S = 5

const ENEMY_SPAWN_DIST_MIN = 500
const ENEMY_SPAWN_DIST_MAX = 1000

func load_enemy_type(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish

var enemies = load_enemy_type("res://common/world/enemies_no_special_compressed.json")

func get_random_player_position():
	var n = len(world.players.values())
	var i = rng.randi_range(0, n - 1)

	return world.players.values()[i].global_position

func get_random_enemy_type():
	var i = rng.randi_range(0, len(enemies))
	return enemies[i]

func get_spawn_position():
	var target_position = get_random_player_position()
	var dist = rng.randi_range(ENEMY_SPAWN_DIST_MIN, ENEMY_SPAWN_DIST_MAX)
	var angle = deg_to_rad(rng.randi_range(0, 360))

	var offset = Vector2(cos(angle), sin(angle)) * dist

	return target_position + offset

func on_spawn_timer_timeout():
	if !Globals.is_server() or world.players.is_empty():
		return
	if Globals.boss_spawned:
		return
	
	var spawn_group_size = 2*(Globals.enemies_killed/10) + 1
	for i in spawn_group_size:
		var enemy = enemy_scene.instantiate() as Enemy
		var enemy_type = get_random_enemy_type()
		enemy.position = get_spawn_position()
		enemy.world = world

		if enemy_type["health"] == "LOW":
			enemy.health = 1
		elif enemy_type["health"] == "HIGH":
			enemy.health = 4

		if enemy_type["speed"] == "LOW":
			enemy.move_speed = 100
		elif enemy_type["speed"] == "HIGH":
			enemy.move_speed = 300

		var image_path: String = enemy_type["image_path"]
		enemy.image_url = "https://proxy.ugo-ii.com/https://commons.wikimedia.org/w/thumb.php?width=120&f=" + image_path.replace(",", "%2C")
		if image_path.to_lower().ends_with("jpg") or image_path.to_lower().ends_with("jpeg"):
			enemy.image_format = 'jpg'
		else:
			enemy.image_format = 'png'
		enemy.enemy_name = enemy_type["name"]
		if Globals.enemies_killed >= 50 && !Globals.boss_spawned:
			enemy.is_boss = true
			enemy.health *= 20
			Globals.boss_spawned = true
			return
		call_deferred('add_child', enemy, true)


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.wait_time = ENEMY_SPAWN_INTERVAL_S / max(1, len(world.players.values()))
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	spawn_timer.start()
