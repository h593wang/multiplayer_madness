class_name Pistol extends Node2D

var bullet_speed = 1000

@onready var opposite = $ChamberPoint.global_position.distance_to(global_position)
@export var bullet_scene: PackedScene

var bullet_count = 0

@onready var bullet_spawner = $bullet_spawner
@onready var bullet_root = $bullet_root

var is_controlled: bool

func _ready():
	bullet_spawner.add_spawnable_scene(bullet_scene.resource_path)
	$BasicShootable.is_controlled = is_controlled

@rpc("any_peer", "call_remote", "reliable")
func rpc_server_fire():
	if multiplayer.get_unique_id() == 1:
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.global_rotation = global_rotation
		var direction = Vector2(cos(global_rotation), sin(global_rotation))
		bullet.fire(
			$BasicShootable/FirePoint.global_position,
			direction,
			bullet_speed
		)
		bullet_count += 1
		bullet.bullet_range = 1000
		bullet_root.add_child(bullet, true)

func _on_shootable_successful_shoot():
	rpc_server_fire.rpc()
