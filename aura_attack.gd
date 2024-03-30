extends Node
class_name AuraAttack

signal deal_damage(event: DamageEvent)

@export var damage := 10
@export var size := 5.0 :
	set(value):
		size = value
		set_size(value)

@onready var collider := $Area3D/CollisionShape3D
@onready var mesh := $Area3D/MeshInstance3D
@onready var area := $Area3D

@onready var stats := $"../../StatsComponent"

@export var seconds_per_attack := 1.0
var time_since_last_attack := 0.0


func _ready():
	set_size(size)

# sync the collider and the mesh to the same size
func set_size(size: float):
	if mesh and collider:
		mesh.mesh.top_radius = size
		mesh.mesh.bottom_radius = size
		collider.shape.radius = size

func _physics_process(delta):
	time_since_last_attack += delta
	while time_since_last_attack > seconds_per_attack:
		time_since_last_attack -= seconds_per_attack
		attack()

func attack():
	var bodies = area.get_overlapping_bodies()

	for body: Node3D in bodies:
		if body.has_node('HealthComponent'):
			var health_component := body.get_node('HealthComponent')
			var damage := calc_damage()
			deal_damage.emit(DamageEvent.create(damage, health_component.global_position))
			health_component.take_damage(damage)

func calc_damage() -> float:
	return damage * (1.0 + stats.attack_damage_buff)

