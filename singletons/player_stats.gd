extends Node


signal level_up(level: int)

class Stats:
	var move_speed := 5.0
	var move_speed_buff := 0.0

	var attack_damage_buff := 0.0

	var attack_range := 5.0
	var attack_range_buff := 0.0

	var pickup_radius := 5.0
	var pickup_radius_buff := 0.0

	var health_regen := 0
	var vampirism := 0.0

	var attack_speed := 0.0

	var xp := 0
	var level := 1
	var xp_to_next_level := 100

var stats = Stats.new()

# delegate getters and setters
# TODO: is there a better way to do this?
var move_speed :
	get:
		return stats.move_speed
	set(value):
		stats.move_speed = value
var move_speed_buff :
	get:
		return stats.move_speed_buff
	set(value):
		stats.move_speed_buff = value
var attack_damage_buff :
	get:
		return stats.attack_damage_buff
	set(value):
		stats.attack_damage_buff = value
var attack_range :
	get:
		return stats.attack_range
	set(value):
		stats.attack_range = value
var attack_range_buff :
	get:
		return stats.attack_range_buff
	set(value):
		stats.attack_range_buff = value
var pickup_radius :
	get:
		return stats.pickup_radius
	set(value):
		stats.pickup_radius = value
var pickup_radius_buff :
	get:
		return stats.pickup_radius_buff
	set(value):
		stats.pickup_radius_buff = value
var health_regen :
	get:
		return stats.health_regen
	set(value):
		stats.health_regen = value
var vampirism :
	get:
		return stats.vampirism
	set(value):
		stats.vampirism = value
var attack_speed :
	get:
		return stats.attack_speed
	set(value):
		stats.attack_speed = value
var xp :
	get:
		return stats.xp
	set(value):
		stats.xp = value
var xp_to_next_level :
	get:
		return stats.xp_to_next_level
	set(value):
		stats.xp_to_next_level = value
var level :
	get:
		return stats.level
	set(value):
		stats.level = value

func reset():
	stats = Stats.new()

func stats_text():
	return 'move_speed: %f\nmove_speed_buff: %f\nattack_damage_buff: %f\nattack_range: %f\nattack_range_buff: %f\nattack_speed: %f\npickup_radius: %f\npickup_radius_buff: %f\nhealth_regen: %d\nvampirism: %f' % [
		move_speed,
		move_speed_buff,
		attack_damage_buff,
		attack_range,
		attack_range_buff,
		attack_speed,
		pickup_radius,
		pickup_radius_buff,
		health_regen,
		vampirism,
	]

func calc_move_speed() -> float:
	return move_speed * (1.0 + move_speed_buff)

func calc_attack_range() -> float:
	return attack_range * (1.0 + attack_range_buff)

func calc_pickup_radius() -> float:
	return pickup_radius * (1.0 + pickup_radius_buff)

func add_xp(value: int):
	xp += value

	while xp > xp_to_next_level:
		xp = xp - xp_to_next_level
		# 50 xp per next level
		xp_to_next_level += 50
		level += 1
		level_up.emit(level)


func select_powerup(powerup: PowerUp, rarity: PowerUp.Rarity):
	match powerup.stat:
		PowerUp.Stat.MOVE_SPEED:
			PlayerStats.move_speed_buff += powerup.rarity_scaling[rarity]
		PowerUp.Stat.ATTACK_DAMAGE:
			PlayerStats.attack_damage_buff += powerup.rarity_scaling[rarity]
		PowerUp.Stat.ATTACK_RANGE:
			PlayerStats.attack_range_buff += powerup.rarity_scaling[rarity]
		PowerUp.Stat.PICKUP_RADIUS:
			PlayerStats.pickup_radius_buff += powerup.rarity_scaling[rarity]
		PowerUp.Stat.HEALTH_REGEN:
			PlayerStats.health_regen += powerup.rarity_scaling[rarity]
		PowerUp.Stat.VAMPIRISM:
			PlayerStats.vampirism += powerup.rarity_scaling[rarity]
		PowerUp.Stat.ATTACK_SPEED:
			PlayerStats.attack_speed += powerup.rarity_scaling[rarity]
