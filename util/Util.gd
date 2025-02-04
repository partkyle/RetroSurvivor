class_name Util

static func random_direction() -> Vector3:
	return Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
