class_name DamagePopup
extends Label3D

@export var time := 0.4
@export var speed := 1.0

@onready var direction := random_direction()

var acc := 0.0

@onready var double_scale := scale * 2.0

func _process(delta):
	transform.origin += direction*speed*delta
	scale = scale.lerp(double_scale, delta)
	acc += delta
	if acc > time:
		queue_free()

func random_direction() -> Vector3:
	#return Vector3(randf_range(-1.0, 0.0), 0.0, randf_range(-1.0,0.0)).normalized()
	return Vector3(randf(), randf(), randf())
