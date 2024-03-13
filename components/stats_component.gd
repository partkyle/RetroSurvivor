extends Node3D

@export var move_speed := 5.0
@export var move_speed_buff := 0.0

@export var attack_damage_buff := 0.0

@export var attack_range := 5.0
@export var attack_range_buff := 0.0

@export var pickup_radius := 5.0
@export var pickup_radius_buff := 0.0

func stats_text():
	return 'move_speed: %f\nmove_speed_buff: %f\nattack_damage_buff: %f\nattack_range: %f\nattack_range_buff: %f\npickup_radius: %f\npickup_radius_buff: %f' % [
		move_speed,
		move_speed_buff,
		attack_damage_buff,
		attack_range,
		attack_range_buff,
		pickup_radius,
		pickup_radius_buff,
	]

func calc_move_speed() -> float:
	return move_speed * (1.0 + move_speed_buff)

func calc_attack_range() -> float:
	return attack_range * (1.0 + attack_range_buff)

func calc_pickup_radius() -> float:
	return pickup_radius * (1.0 + pickup_radius_buff)
