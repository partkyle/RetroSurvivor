extends Node3D


@export var player : Player
@export var xpSpawner : XpSpawner

func _input(event: InputEvent):
	if event is InputEventKey and event.keycode == KEY_F2:
		PlayerStats.add_xp(100000)
	if event is InputEventKey and event.keycode == KEY_F3:
		LevelStats.current_stats.level += 1
