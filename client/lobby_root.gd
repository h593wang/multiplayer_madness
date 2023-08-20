extends Node2D

func _ready():
	Globals.player_dead.connect(set_show_lobby)

func set_show_lobby(should_show: bool = true):
	visible = should_show
	if (should_show):
		$Camera2D.make_current()
		var game_instance = get_tree().root.get_node("GameInstance")
		if game_instance != null:
			game_instance.queue_free()
