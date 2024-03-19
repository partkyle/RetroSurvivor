class_name Xp
extends Node3D

const DURATION = 0.2
const SPEED = 10.0
const EPSILON = 0.01

@export var value = 10

var target : Node3D
var signal_bus : SignalBus

var speed := SPEED

func _process(delta):
	if target:
		speed += 0.1
		global_position = global_position.move_toward(target.global_position, speed * delta)
		if (target.global_position - global_position).length() < EPSILON:
			signal_bus.gain_xp.emit(value)
			queue_free()


func pickup(t: Node3D):
	target = t
