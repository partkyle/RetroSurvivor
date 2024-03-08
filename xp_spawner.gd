class_name XpSpawner
extends Node3D

@export var xp : PackedScene

func _on_signal_bus_enemy_died(enemy: Enemy):
	var e = xp.instantiate()
	e.transform.origin = enemy.transform.origin
	e.signal_bus = %SignalBus
	add_child(e)
