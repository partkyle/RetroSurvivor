class_name Enemy
extends CharacterBody3D

signal death(enemy: Enemy)

const SPEED := 3.0
const EPISLON := 0.1

@onready var mesh := $MeshInstance3D
@onready var collider := $CollisionShape3D
@onready var health_bar : HealthBar  = $HealthBar
@onready var health_component : HealthComponent = $HealthComponent

var target : Node3D
var desired_velocity: Vector3
@export var acceleration := 5.0
@export var damage := 10

var signal_bus : SignalBus

func _physics_process(delta):
	if target:
		var direction := target.global_position - global_position

		if direction.length() > EPISLON:
			desired_velocity = Vector3(direction.x, 0.0, direction.z).normalized() * SPEED
	else:
		desired_velocity = Vector3.ZERO

	velocity = velocity.move_toward(desired_velocity, acceleration * delta)

	if desired_velocity:
		var l = global_position + desired_velocity * 100
		if l == global_position:
			print('here')
		look_at(l)

	move_and_slide()


func set_signal_bus(bus: SignalBus):
	signal_bus = bus

func die():
	death.emit(self)
	signal_bus.enemy_died.emit(self)
	collider.queue_free()
	health_bar.queue_free()
	target = null
	create_tween() \
		.set_ease(Tween.EASE_OUT) \
		.tween_method(set_dissolve_height, 1.0, 0.0, 1.2) \
		.connect('finished', func() : queue_free())

func set_dissolve_height(height: float):
	mesh.material_override.set_shader_parameter('dissolve_height', height)

func _on_health_component_health_below_zero():
	die()

func _on_health_component_health_updated(current, total):
	health_bar.set_health_percent(float(current)/float(total))
	mesh.material_override.set_shader_parameter("flash", 1)
	get_tree().create_timer(0.2).connect('timeout', func(): mesh.material_override.set_shader_parameter("flash", 0))
