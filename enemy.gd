class_name Enemy
extends CharacterBody3D

signal death(enemy: Enemy)

const SPEED := 2.0
const EPISLON := 0.1

@onready var damage_notifier_position := $DamageNotifierPosition

@onready var mesh := $MeshInstance3D
@onready var collider := $CollisionShape3D
@onready var health_bar : HealthBar  = $HealthBar
@onready var health_component : HealthComponent = $HealthComponent

var target : Node3D

@export var max_health := 30

var signal_bus : SignalBus

func _ready():
	health_component.max_health = max_health
	health_component.health = max_health

#func _process(delta):
	#if target:
		#var direction = target.transform.origin - transform.origin
		#transform.origin = transform.origin.move_toward(target.transform.origin, SPEED * delta)

func _physics_process(delta):
	if target:
		var direction := target.global_position - global_position
		if direction.length() > EPISLON:
			velocity = Vector3(direction.x, 0.0, direction.z).normalized() * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.y = move_toward(velocity.y, 0.0, SPEED)

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
