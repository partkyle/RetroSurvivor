extends Node3D


@export var player : Player
@export var xpSpawner : XpSpawner

func _input(event: InputEvent):
	if event is InputEventKey and event.keycode == KEY_F2:
		for i in range(1000):
			xpSpawner.spawn_xp_at_position(player.global_position)
	if event is InputEventKey and event.keycode == KEY_F3:
		LevelStats.current_stats.level += 1
