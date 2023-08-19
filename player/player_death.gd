class_name PlayerDeath extends Node2D

func _on_button_pressed():
	Globals.player_dead.emit()
	get_parent().queue_free()
	
