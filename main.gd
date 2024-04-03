extends Node3D

func _ready():
	SceneManager.load_new_scene.emit(true)
