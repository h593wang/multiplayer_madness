extends Node2D

func _ready():
	Globals.player_dead.connect(set_show_lobby)

func set_show_lobby(show: bool = true):
	print(show)
	visible = show
	if (show):
		$Camera2D.make_current()
		var game_instance = get_tree().root.get_node("GameInstance")
		if game_instance != null:
			game_instance.queue_free()
		var game_world = get_tree().root.get_node("GameWorld")
		if game_world != null:
			game_world.queue_free()
