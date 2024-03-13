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

@export var pickup_radius := 5.0

func _ready():
	var pickup_shape :=  CylinderShape3D.new()
	pickup_shape.radius = pickup_radius
	pickup_collider.shape = pickup_shape

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * stats.move_speed
		velocity.z = direction.z * stats.move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, stats.move_speed)
		velocity.z = move_toward(velocity.z, 0, stats.move_speed)

	move_and_slide()


func _on_signal_bus_enemy_died(enemy):
	attack_aura.upgrade()
	pass


func _on_pickup_body_entered(body):
	if body is Xp:
		body.pickup(self)

func _on_signal_bus_gain_xp(value):
	_add_xp(value)

func _add_xp(value: int):
	xp += value

	var levels_gained := xp / xp_to_next_level
	for i in range(levels_gained):
		level += 1
		level_up.emit(level)

	xp %= xp_to_next_level
	gain_xp.emit(xp, xp_to_next_level)

