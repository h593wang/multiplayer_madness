extends Node2D

func _ready():
	Globals.player_dead.connect(set_show_lobby)

func set_show_lobby(should_show: bool = true):
	visible = should_show
	if (should_show):
		$lobby_ui/join_button.disabled = false
		$lobby_ui/join_button.text = "Join"
		$lobby_ui/host_button.disabled = false
		$lobby_ui/host_button.text = "host"
		$Camera2D.make_current()
		var game_instance = get_tree().root.get_node("GameInstance")
		if game_instance != null:
			game_instance.queue_free()
