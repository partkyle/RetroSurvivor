extends Node3D
class_name AuraAttack

@export var damage := 100
@export var size := 5.0 :
	set(value):
		size = value
		set_size(value)

@onready var collider := $Area3D/CollisionShape3D
@onready var mesh := $Area3D/MeshInstance3D
@onready var timer := $Timer
@onready var area := $Area3D


func _ready():
	# ensure this gets done
	set_size(size)

func set_size(size: float):
	if mesh and collider:
		mesh.mesh.top_radius = size
		mesh.mesh.bottom_radius = size
		collider.shape.radius = size

func _physics_process(delta):
	if timer.is_stopped():
		var bodies = area.get_overlapping_bodies()

		for body in bodies:
			if body.has_method('take_damage'):
				body.take_damage(damage)

		timer.start()


func upgrade():
	return
	if damage < 1000:
		damage *= 1.1
	timer.wait_time *= 0.9
	area.scale += Vector3(0.005, 0.0, 0.005)
	print('damage increased to %d' % [damage])

