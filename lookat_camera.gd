extends Camera3D


@export var target : Node3D

func _process(_delta: float):
	if target:
		look_at(target.transform.origin)

