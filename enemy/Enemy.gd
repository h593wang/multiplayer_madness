class_name Enemy extends Node2D

@export var world: MMWorld

@onready var target_timer = $target_timer

@export var retarget_time_secs = 2
@export var move_speed = 300

var target_player: Node2D = null

func get_closest_player():
	var players = world.players.values()
	var closest = null
	
	var min_dist = 999999999999999
	
	for p in players:
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
		return
		
	if target_player != null:
		position = position.move_toward(target_player.position, move_speed * delta)
		
