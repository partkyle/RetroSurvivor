extends CharacterBody3D
class_name Enemy

const SPEED := 2.0
const EPISLON := 0.1

@onready var mesh := $MeshInstance3D
@onready var collider := $CollisionShape3D

var target : Node3D

var health := 100 :
	set(value):
		health = value
		mesh.material_override.set_shader_parameter('mix_amount', 1.0-float(health)/float(max_health))

var max_health := 100

var signal_bus : SignalBus

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		die()

func _physics_process(delta):
	if target:
		var direction = target.transform.origin - transform.origin
		transform = transform.looking_at(target.transform.origin, Vector3.UP)
		transform.origin = transform.origin.move_toward(target.transform.origin, SPEED * delta)

	# need to figure out if colliders is correct
	#if target:
		#var direction := transform.basis * (target.transform.origin - transform.origin)
		#print(direction, ' ', direction.length())
		#if direction.length() > EPISLON:
			#velocity = Vector3(direction.x, 0.0, direction.z).normalized() * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0.0, SPEED)
			#velocity.y = move_toward(velocity.y, 0.0, SPEED)
	#move_and_slide()


func set_signal_bus(bus: SignalBus):
	signal_bus = bus

func die():
	collider.free()
	signal_bus.enemy_died.emit(self)
	target = null
	create_tween().set_ease(Tween.EASE_OUT).tween_method(set_dissolve_height, 1.0, 0.0, 1.2).connect('finished', func() : queue_free())

func set_dissolve_height(height: float):
	mesh.material_override.set_shader_parameter('dissolve_height', height)
