extends Node

const ENEMY_SPAWNER_TOTEM = preload("res://enemies/enemy_spawner_totem.tscn")
const BOSS_ENEMY = preload("res://enemies/boss_enemy.tscn")

@export var count := 3

var boss_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var totem = ENEMY_SPAWNER_TOTEM.instantiate()
	add_child(totem)
	totem.global_position = Vector3(randf_range(-100, 100), 0, randf_range(-100, 100))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_boss():
	if boss_spawned:
		return

	var e := boss.instantiate()
	e.target = player
	e.set_signal_bus(signal_bus)
	e.connect('death', spawn_extraction)
	spawn_parent.add_child(e)
	e.global_position = spawn_near_target.global_position + Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)) * 10.0
	signal_bus.enemy_spawned.emit(e)
	boss_spawned = true


func spawn_extraction(_enemy: Enemy):
	var e := extraction.instantiate()
	extraction_parent.add_child(e)
	e.global_position = Vector3.ZERO
