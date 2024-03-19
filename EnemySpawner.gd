class_name EnemySpawner
extends Node3D

@export var enemy : PackedScene
@export var spawn_radius := Vector2(4, 10)
@export var max_count := 25
@export var spawn_point : Node3D = self
@export var enemy_parent : Node3D = self

@export var seconds_per_enemy := 0.125
var time_since_last_spawn := 0.0

@export var player : Player
@export var signal_bus : SignalBus

var total := 0

func spawn_enemy():
	if total <= max_count:
		total += 1
		var new_enemy = enemy.instantiate()
		new_enemy.transform.origin = spawn_point.transform.origin + random_direction() * randf_range(spawn_radius.x, spawn_radius.y)
		enemy_parent.add_child(new_enemy)
		signal_bus.enemy_spawned.emit(new_enemy)
		new_enemy.set_signal_bus(signal_bus)
		new_enemy.target = player
		new_enemy.connect('death', _on_enemy_death)

func _process(delta: float):
	# todo: we won't want to have to rely on this ready state synchronization
	# need to figure out a better pattern
	if not signal_bus:
		return
	time_since_last_spawn += delta
	while time_since_last_spawn >= seconds_per_enemy:
		time_since_last_spawn -= seconds_per_enemy
		if total < max_count:
			spawn_enemy()

func random_direction() -> Vector3:
	return Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()

func _on_enemy_death(enemy: Enemy):
	total -= 1
