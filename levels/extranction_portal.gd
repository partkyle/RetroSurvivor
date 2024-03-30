extends Node3D


func _ready():
	print('spawned extraction')

func _on_area_3d_body_entered(body):
	if body is Player:
		SceneManager.load_arena()
		queue_free()
