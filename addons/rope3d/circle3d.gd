extends Object
class_name Circle3D

var _rng = RandomNumberGenerator.new()


# circle
var center: Vector3
var radius: float
var normal: Vector3
var vector_a: Vector3
var vector_b: Vector3


func _init(_center: Vector3, _radius: float, _normal: Vector3):
	center = _center
	radius = _radius
	normal = _normal

	_calc_vectors()


func _calc_vectors():
	var unit = Vector3.UP
	if not unit.cross(normal) == Vector3.ZERO:
		vector_a = unit.cross(normal).normalized()
	else:
		unit = Vector3.RIGHT
		vector_a = unit.cross(normal).normalized()

	vector_b = normal.cross(vector_a).normalized()


func get_point(theta: float) -> Vector3:
	var point := center + radius * cos(theta) * vector_a + radius * sin(theta) * vector_b
	return point
