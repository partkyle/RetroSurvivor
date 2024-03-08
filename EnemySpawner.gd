extends Node3D

@export var enemy : PackedScene
@export var spawn_area_x := Vector2(-10, 10)
@export var spawn_area_y := Vector2(-10, 10)
@export var spawn_radius := Vector2(4, 10)
@export var max_count := 25

@onready var player = $"../Player"

var total := 0

func spawn_enemy():
	var new_enemy = enemy.instantiate()
	new_enemy.transform.origin = player.transform.origin + random_direction() * randf_range(spawn_radius.x, spawn_radius.y)
	add_child(new_enemy)
	%SignalBus.enemy_spawned.emit(new_enemy)
	new_enemy.set_signal_bus(%SignalBus)
	new_enemy.target = player

func _on_timer_timeout():
	if total < max_count:
		spawn_enemy()

func random_direction() -> Vector3:
	return Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()


func _on_signal_bus_enemy_spawned(enemy):
	total+=1


func _on_signal_bus_enemy_died(enemy):
	total-=1
