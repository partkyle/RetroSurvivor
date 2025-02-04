extends Node

const WALL = preload("res://environment/wall.tscn")

@export var count := 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mid := count / 2

	for z in range(-mid, mid):
		add_wall(-mid, z)
		add_wall(mid, z)

	for x in range(-mid, mid):
		add_wall(x, -mid)
		add_wall(x, mid)

func add_wall(x: int, z: int) -> void:
	var wall = WALL.instantiate()
	add_child(wall)
	wall.global_position = pos_for(x, z)

func pos_for(x: int, z: int) -> Vector3:
	return Vector3(x + 0.5, 0, z + 0.5)
