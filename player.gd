extends CharacterBody3D
class_name Player

signal level_up(level: int)
signal deal_damage(event: DamageEvent)
signal death()

@onready var mesh := $MeshInstance3D
@onready var attack_aura : AuraAttack = $Attacks/Aura
@onready var pickup_collider := $Pickup/CollisionShape3D
@onready var health_bar := $HealthBar
@onready var health_component := $HealthComponent

@export var pickup_radius := 5.0 :
	set(value):
		pickup_radius = value
		set_pickup_radius(pickup_radius)

func set_pickup_radius(radius: float):
	var pickup_shape :=  CylinderShape3D.new()
	pickup_shape.radius = radius
	pickup_collider.shape = pickup_shape

func _ready():
	# TODO: setting these stats on ready sucks
	attack_aura.size = PlayerStats.calc_attack_range()
	pickup_radius = PlayerStats.calc_pickup_radius()
	set_pickup_radius(pickup_radius)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var move_speed = PlayerStats.calc_move_speed()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	if Input.is_action_just_pressed("dash"):
		velocity *= 100

	move_and_slide()


func _on_pickup_body_entered(body):
	if body is Xp:
		body.pickup(self)

func _on_signal_bus_gain_xp(value):
	_add_xp(value)

func _add_xp(value: int):
	PlayerStats.add_xp(value)

func _on_health_component_health_below_zero():
	death.emit()

func _on_aura_deal_damage(event: DamageEvent):
	deal_damage.emit(event)
	var vamp := ceili(PlayerStats.vampirism * float(event.damage))
	if vamp:
		var amount = health_component.heal(vamp)
		if amount:
			deal_damage.emit(DamageEvent.create(amount, health_component.global_position, Color.GREEN, 1.2))

func _on_health_component_health_updated(current, total):
	health_bar.set_health_percent(float(current)/float(total))
	mesh.material_override.set_shader_parameter("flash", 1)
	get_tree().create_timer(0.2).connect('timeout', func(): mesh.material_override.set_shader_parameter("flash", 0))

func _on_heal_per_second_timer_timeout():
	if PlayerStats.health_regen:
		var amount = health_component.heal(PlayerStats.health_regen)
		if amount:
			deal_damage.emit(DamageEvent.create(amount, health_component.global_position, Color.GREEN, 1.2))
