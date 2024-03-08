class_name HealthBar
extends Node3D

@onready var mesh : MeshInstance3D = $MeshInstance3D

func set_health_percent(percent: float):
	mesh.material_override.set_shader_parameter('health_percent', percent)
