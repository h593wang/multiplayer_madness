class_name GameEnd extends Node2D
@export var is_win = false
func _ready():
	if is_win:
		$ColorRect.color = Color("fff300", 0.1)
		$Label.text = "You Win!"
		$Button.text = "Continue"


func _on_button_pressed():
	if is_win:
		Globals.game_win.emit()
	Globals.player_dead.emit()
	get_parent().queue_free()
	
