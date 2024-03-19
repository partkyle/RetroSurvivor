class_name HealthComponent
extends Node3D

signal health_below_zero()
signal health_updated(current: int, total: int)

@export var max_health := 100
@export var health := max_health


func take_damage(damage: int):
	health -= damage
	health_updated.emit(health, max_health)
	if health <= 0:
		health_below_zero.emit()
