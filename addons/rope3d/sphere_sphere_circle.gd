# https://www.zhihu.com/question/39049685
# https://blog.sina.com.cn/s/blog_6496e38e0102vi7e.html

class_name SphereSphereCircle
extends Object

var _rng = RandomNumberGenerator.new()

# spheres
var _sphere_a_center: Vector3
var _sphere_a_radius: float

var _sphere_b_center: Vector3
var _sphere_b_radius: float

var _sphere_sphere_distance: float


# triangle
var cosA: float
var a: float
var b: float
var c: float


# circle
var center: Vector3
var radius: float
var vector_a: Vector3
var vector_b: Vector3
var normal: Vector3


func _init(sphere_a_position: Node3D, sphere_a_radius: float, \
	sphere_b_position: Node3D, sphere_b_radius: float):
	_sphere_a_center = sphere_a_position.global_transform.origin
	_sphere_a_radius = sphere_a_radius
	_sphere_b_center = sphere_b_position.global_transform.origin
	_sphere_b_radius = sphere_b_radius
	_sphere_sphere_distance = _sphere_a_center.distance_to(_sphere_b_center)
	
	_calc_center()
	_calc_radius()
	_calc_vectors()


func _calc_center():	
	a = _sphere_b_radius
	b = _sphere_a_radius
	c = _sphere_sphere_distance
	cosA = (pow(b, 2) + pow(c, 2) - pow(a, 2)) / (2 * b * c)
	
	var k := b * cosA / c
	normal = _sphere_b_center - _sphere_a_center
	center = _sphere_a_center + k * normal


func _calc_radius():
#	var dividend := sqrt(2.0 * pow(c, 2) * (pow(a, 2) + pow(b, 2)) - pow(pow(a, 2) - pow(b, 2), 2) - pow(c, 4))
#	var divider := 2.0 * c
#	radius = dividend / divider
	var sinA = sqrt(1 - pow(cosA, 2))
	radius = b * sinA


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
