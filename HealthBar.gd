class_name HealthBar
extends Node3D

@onready var mesh : MeshInstance3D = $MeshInstance3D

@export var health_percent : float = 1.0 :
	set(value):
		health_percent = value
		set_health_percent(health_percent)

func set_health_percent(percent: float):
	mesh.material_override.set_shader_parameter('fillPercent', percent)
