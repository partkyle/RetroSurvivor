extends CanvasItem


func _on_player_death():
	show()
	get_tree().paused = true
