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
		transform.origin = transform.origin.move_toward(target.transform.origin, speed * delta)
		if (target.transform.origin - transform.origin).length() < EPSILON:
			signal_bus.gain_xp.emit(value)
			queue_free()


func pickup(t: Node3D):
	target = t
