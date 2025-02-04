extends Node3D

var used = false

func _on_area_3d_body_entered(body):
	if not used and body is Player:
		SceneManager.load_new_scene.emit(false)
		used = true
