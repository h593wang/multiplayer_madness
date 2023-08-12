class_name RecoilForce extends Node2D

@export var recoil_duration_seconds: float
@export var recoil_force_initial: int

var current_forces: Array

func _process(delta):
	# get the character to apply force to
	var target = get_parent().get_parent() as PhysicsBody2D
	if current_forces.size() > 0 and target != null:
		# set up the new forces and the force to apply
		var new_forces = []
		var cur_force = Vector2.ZERO
		# calculating the net force to apply
		for force in current_forces:
			var force_direction = force[1]
			var force_duration = force[0]
			cur_force += -force_direction * recoil_force_initial * force_duration / recoil_duration_seconds
			
			# updating the duration after processing
			var new_duration = force[0] - delta
			if new_duration > 0:
				new_forces.append([new_duration, force[1]])
		# update the current_forces after processing
		current_forces.clear()
		current_forces.append_array(new_forces)
		
		# move character
		target.velocity = cur_force
		target.move_and_slide()


func start_recoil():
	var current_direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	var current_duration = recoil_duration_seconds
	
	current_forces.append([recoil_duration_seconds, current_direction])
