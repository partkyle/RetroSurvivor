class_name DamageEvent
extends Object

var damage: int
var global_position: Vector3

static func create(_damage: int, _global_position: Vector3) -> DamageEvent:
	var de = DamageEvent.new()
	de.damage = _damage
	de.global_position = _global_position
	return de
