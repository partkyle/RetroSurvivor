extends CharacterBody3D
class_name Player

signal level_up(level: int)
signal gain_xp(xp: int, xp_to_next_level: int)


var xp := 0
var level := 1
var xp_to_next_level := 100

@onready var stats := $StatsComponent
@onready var attack_aura : AuraAttack = $Attacks/Aura
@onready var pickup_collider := $Pickup/CollisionShape3D

@export var pickup_radius := 5.0 :
	set(value):
		pickup_radius = value
		set_pickup_radius(pickup_radius)

func set_pickup_radius(radius: float):
	var pickup_shape :=  CylinderShape3D.new()
	pickup_shape.radius = radius
	pickup_collider.shape = pickup_shape

func _ready():
	set_pickup_radius(pickup_radius)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var move_speed = stats.calc_move_speed()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()


func _on_pickup_body_entered(body):
	if body is Xp:
		body.pickup(self)

func _on_signal_bus_gain_xp(value):
	_add_xp(value)

func _add_xp(value: int):
	xp += value

	while xp > xp_to_next_level:
		xp = xp - xp_to_next_level
		# 50 xp per next level
		xp_to_next_level += 50
		level += 1
		level_up.emit(level)
		gain_xp.emit(xp, xp_to_next_level)


	gain_xp.emit(xp, xp_to_next_level)



func _on_upgrade_select_select_powerup(powerup: PowerUp, rarity: PowerUp.Rarity):
	print(powerup.name, rarity)
	match powerup.stat:
		PowerUp.Stat.MOVE_SPEED:
			stats.move_speed_buff += powerup.rarity_scaling[rarity]
		PowerUp.Stat.ATTACK_DAMAGE:
			stats.attack_damage_buff += powerup.rarity_scaling[rarity]
		PowerUp.Stat.ATTACK_RANGE:
			stats.attack_range_buff += powerup.rarity_scaling[rarity]
			attack_aura.size = stats.calc_attack_range()
		PowerUp.Stat.PICKUP_RADIUS:
			stats.pickup_radius_buff += powerup.rarity_scaling[rarity]
			pickup_radius = stats.calc_pickup_radius()

	%SignalBus.stats_updated.emit(stats.stats_text())
