extends Node3D
class_name AuraAttack

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

	for body in bodies:
		if body.has_method('take_damage'):
			body.take_damage(calc_damage())

func calc_damage():
	return damage * (1.0 + stats.attack_damage_buff)
