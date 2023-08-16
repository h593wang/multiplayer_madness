class_name Pistol extends Node2D

var bullet_speed = 1000

@onready var opposite = $ChamberPoint.global_position.distance_to(global_position)
@export var bullet_scene: PackedScene

var bullet_count = 0

@onready var bullet_spawner = $bullet_spawner
@onready var bullet_root = $bullet_root

func _ready():
	bullet_spawner.set_multiplayer_authority(str(name).to_int())
	bullet_spawner.add_spawnable_scene(bullet_scene.resource_path)
	
	$BasicShootable.is_authority = bullet_spawner.is_multiplayer_authority()

func _on_shootable_successful_shoot():
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.id = str(name).to_int()
	bullet.global_rotation = global_rotation
	var direction = Vector2(cos(global_rotation), sin(global_rotation))
	bullet.fire(
		$BasicShootable/FirePoint.global_position,
		direction,
		bullet_speed
	)
	bullet.name = str(name) + str(bullet_count)
	bullet_count += 1
	bullet.range = 1000
	bullet_root.add_child(bullet)
