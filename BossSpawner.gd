extends Node3D

const ENEMY_SPAWNER_TOTEM = preload("res://enemies/enemy_spawner_totem.tscn")
const BOSS_ENEMY = preload("res://enemies/boss_enemy.tscn")
const EXTRANCTION_PORTAL = preload("res://levels/extranction_portal.tscn")

@onready var extraction_parent : Node = $".."
@export var signal_bus : SignalBus
@export var spawn_near_target : Node3D
@export var spawn_parent : Node3D
@export var player : Node3D
@export var objective_range: Vector2 = Vector2(-10, 10)
@onready var enemy_parent: Node3D = $"../EnemyParent"

var watch_list : Array[Node3D]

var total := 0
var boss_spawned = false

func spawn_boss():
	if boss_spawned:
		return

	var e := BOSS_ENEMY.instantiate()
	e.target = player
	e.set_signal_bus(signal_bus)
	e.connect('death', spawn_extraction)
	spawn_parent.add_child(e)
	e.global_position = spawn_near_target.global_position + Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)) * 10.0
	signal_bus.enemy_spawned.emit(e)
	boss_spawned = true

func spawn_extraction(_enemy: Enemy):
	var e := EXTRANCTION_PORTAL.instantiate()
	extraction_parent.add_child(e)
	e.global_position = Vector3.ZERO


func _ready():
	for i in range(0, 3):
		var totem = ENEMY_SPAWNER_TOTEM.instantiate()
		totem.player = player
		totem.signal_bus = signal_bus
		totem.enemy_parent = enemy_parent
		add_child(totem)
		totem.global_position = Vector3(randf_range(objective_range.x, objective_range.y), 0, randf_range(objective_range.x, objective_range.y))
		watch_list.push_back(totem)
		totem.connect('tree_exited', func(): total -= 1)
		total += 1

func _process(delta: float):
	if total <= 0 && not boss_spawned:
		spawn_boss()
