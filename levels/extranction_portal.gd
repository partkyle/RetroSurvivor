extends Node3D

func _ready():
	print('spawned extraction')


var used = false

func _on_area_3d_body_entered(body):
	if not used and body is Player:
		#PlayerStats.level_up.emit(-1)
		SceneManager.load_new_scene.emit(false)
		used = true
