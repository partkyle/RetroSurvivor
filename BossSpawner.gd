extends Node3D


@export var boss : PackedScene
@export var extraction : PackedScene
@onready var extraction_parent : Node = $".."
@export var signal_bus : SignalBus
@export var spawn_near_target : Node3D
@export var spawn_parent : Node3D
@export var watch_list : Array[Node3D]
@export var player : Node3D

var total := 0
var boss_spawned = false

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


func _ready():
	total = watch_list.size()
	print('waiting for %d totems' % total)
	for w in watch_list:
		w.connect('tree_exiting', func(): total -= 1)

func _process(delta: float):
	if total <= 0 && not boss_spawned:
		spawn_boss()
