class_name DamagePopup
extends Label3D

@export var time := randf_range(0.4, 0.6)
@export var speed := 0.1
@export var alpha_scaling := 8.0

@onready var direction := random_direction()

var acc := 0.0

@onready var double_scale := scale * randf_range(1.2, 2.0)

func _process(delta):
	transform.origin += direction*speed*delta
	scale = scale.lerp(double_scale, delta)

	modulate.a = lerp(modulate.a, 0.0, delta * alpha_scaling)
	outline_modulate.a = lerp(outline_modulate.a, 0.0, delta * alpha_scaling)

	acc += delta
	if acc > time:
		queue_free()

func random_direction() -> Vector3:
	#return Vector3(randf_range(-1.0, 0.0), 0.0, randf_range(-1.0,0.0)).normalized()
	return Vector3(randf(), randf(), randf())
