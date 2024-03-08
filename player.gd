extends CharacterBody3D
class_name Player

signal xp_updated(total_xp: int)
signal level_up(level: int, xp: int)

const SPEED = 5.0

var xp := 0
var total_xp := 0
var level := 1

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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

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
	total_xp += value
	xp_updated.emit(total_xp)
	xp += value
	_level_up()

func _level_up():
	var xp_to_level := 100
	level += xp / xp_to_level
	print(xp, ' ', xp / xp_to_level, ' ', level)
	xp %= xp_to_level
	level_up.emit(level, xp)
