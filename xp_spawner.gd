class_name XpSpawner
extends Node3D

@export var xp_root : Node
@export var xp : PackedScene

@onready var signal_bus := %SignalBus

func _ready():
	if !xp_root:
		xp_root = self

func _on_signal_bus_enemy_died(enemy: Enemy):
	spawn_xp_at_position(enemy.global_position)

func spawn_xp_at_position(pos: Vector3):
	var e = xp.instantiate()
	e.signal_bus = signal_bus
	e.value = e.value * LevelStats.current_stats.level
	if PlayerStats.stats.level < LevelStats.current_stats.level:
		e.value *= LevelStats.current_stats.level
	PlayerStats.add_xp(e.value)
	xp_root.add_child(e)
	e.global_position = pos
