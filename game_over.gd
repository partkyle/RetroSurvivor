extends CanvasItem

var dead := false

func _on_player_death():
	dead = true
	show()
	get_tree().paused = true

func _input(event: InputEvent):
	if dead and event.is_action("game_reload"):
		get_tree().paused = false
		SceneManager.load_arena()
