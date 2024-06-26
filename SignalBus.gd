extends Node3D
class_name SignalBus

signal enemy_died(enemy: Enemy)
signal enemy_spawned(enemy: Enemy)
signal pause_game()
signal unpause_game()

signal damage_dealt(event: DamageEvent)


func _on_pause_game():
	get_tree().paused = true


func _on_unpause_game():
	get_tree().paused = false


func _on_enemy_died(enemy):
	LevelStats.kills += 1


func _on_enemy_spawned(enemy):
	LevelStats.total += 1
