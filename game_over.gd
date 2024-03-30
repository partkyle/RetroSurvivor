extends CanvasItem

var dead := false

func _on_player_death():
	dead = true
	show()
	get_tree().paused = true

func _input(event: InputEvent):
	if dead and event.is_action("game_reload"):
		start_new_game()

func _on_button_pressed():
	start_new_game()

func start_new_game():
	get_tree().paused = false
	SceneManager.reset_arena()
