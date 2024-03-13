extends Node3D
class_name SignalBus

signal enemy_died(enemy: Enemy)
signal enemy_spawned(enemy: Enemy)
signal gain_xp(value: int)
signal pause_game()
signal unpause_game()


func _on_pause_game():
	get_tree().paused = true


func _on_unpause_game():
	get_tree().paused = false
