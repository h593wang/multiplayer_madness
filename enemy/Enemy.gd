class_name Enemy extends CharacterBody2D

@export var world: MMWorld
@export var hurt: String
@export var previous: String

@onready var target_timer = $target_timer

@export var retarget_time_secs = 2
@export var move_speed = 200
@export var health = 2

@export var death_rotation: float
var death_scene = preload("res://enemy/EnemyDeath.tscn")

var target_player: Node2D = null

func get_closest_player():
	var players = world.players.values()
	var closest = null
	
	var min_dist = 999999999999999
	
	for p in players:
		if p.dead:
			continue
		var dist = global_position.distance_to(p.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = p
			
	return closest

func retarget():
	target_player = get_closest_player()

func _ready():
	if Globals.is_server():
		target_timer.wait_time = retarget_time_secs
		target_timer.timeout.connect(retarget)
		target_timer.start()
		
		# Do an initial retarget so we have one set from the beginning
		retarget()
		
func _process(delta):
	if !Globals.is_server():
		if hurt != null and hurt != previous:
			previous = hurt
			$AnimationPlayer.play("hurt")
		return
	
	if target_player != null:
		var angle = (target_player.global_position - global_position).normalized()
		set_velocity(angle * move_speed)
		move_and_slide()
		
	for body in $Area2D.get_overlapping_bodies():
		if body is Bullet:
			hurt = OS.get_unique_id()
			body.queue_free()
			health -= 1
			death_rotation = body.global_rotation
			if health == 0:
				Globals.enemies_killed += 1
				queue_free()



func _exit_tree():
	var death_particle = death_scene.instantiate()
	death_particle.global_rotation = death_rotation
	death_particle.global_position = global_position
	get_tree().root.add_child(death_particle)
