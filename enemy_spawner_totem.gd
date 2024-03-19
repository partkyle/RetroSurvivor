class_name EnemySpawnerTotem
extends CharacterBody3D

@export var player: Player
@export var signal_bus: SignalBus
@export var enemy_parent: Node3D = self

@onready var health_bar := $HealthBar
@onready var spawner := $EnemySpawner

func _ready():
	spawner.player = player
	spawner.signal_bus = signal_bus
	spawner.enemy_parent = enemy_parent

func _on_health_component_health_below_zero():
	print('killed spawner')
	for child in spawner.get_children():
		if child is Enemy:
			child.die()

	queue_free()

func _on_health_component_health_updated(current, total):
	health_bar.set_health_percent(float(current)/float(total))
