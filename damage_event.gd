class_name DamageEvent
extends Object

var damage: int
var global_position: Vector3
var color : Color
var scale : float = 1.0

static func create(_damage: int, _global_position: Vector3, _color: Color = Color.WHITE, _scale: float = 1.0) -> DamageEvent:
	var de = DamageEvent.new()
	de.damage = _damage
	de.global_position = _global_position
	de.color = _color
	de.scale = _scale
	return de
