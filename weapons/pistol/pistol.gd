class_name Pistol extends Node2D

var bullet_speed = 1000
@onready var opposite = $ChamberPoint.global_position.distance_to(global_position)
@export var bullet_scene: PackedScene

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _on_shootable_successful_shoot():
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.get_node("MultiplayerSynchronizer").set_multiplayer_authority(str(name).to_int())
	bullet.global_rotation = global_rotation
	var direction = Vector2(cos(global_rotation), sin(global_rotation))
	bullet.fire(
		$BasicShootable/FirePoint.global_position,
		direction,
		bullet_speed
	)
	get_node("/root/MainScene/Network").add_child(bullet)
