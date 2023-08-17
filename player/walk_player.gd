class_name PlayerWalkSounds extends Node

@onready var timer = $walk_timer
@onready var player = $stream_player

var randomizer = AudioStreamRandomizer.new()

var sound_idx = 0

const WALK_TIMER_INTERVAL_S = 0.3

func on_walk_timer_timeout():
	player.play()
	
func on_walk_start():
	timer.start()
	# Play an initial sound
	on_walk_timer_timeout()
	
func on_walk_end():
	timer.stop()
	timer.wait_time = WALK_TIMER_INTERVAL_S

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = WALK_TIMER_INTERVAL_S
	timer.timeout.connect(on_walk_timer_timeout)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
