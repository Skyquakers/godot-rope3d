extends Node3D
class_name Rope3D

const RopeSegmentScene: PackedScene = preload("./RopeSegment.tscn")
const Circle: GDScript = preload("./sphere_sphere_circle.gd")

@export var resolution := 1
@export var rope_length := 10.0
@export var segment_length := 0.1
@export var start_point: Node3D
@export var end_point: Node3D
@export var radius := 0.1


var segments := []
var head_anchor: PhysicsBody3D
var tail_anchor: PhysicsBody3D

var _rng := RandomNumberGenerator.new()
var _distance := 0.0
var _circle: SphereSphereCircle
var _turning_point_draw: Vector3 = Vector3.ZERO
var _turning_index := 0
var _joint_length := 0.0

var _generated := false


@onready var rope_mesh: RopeMesh = $RopeMesh

var middle_point: Vector3 :
	get:
		if start_point == null or end_point == null:
			return Vector3.ZERO
		
		return start_point.global_transform.origin + (end_point.global_transform.origin - start_point.global_transform.origin) / 2.0


func can_make() -> bool:
	return _prepare()


func make() -> bool:
	var ok = _prepare()
	if ok:
		call_deferred("_generate")
		_generated = true
		return true
	
	return false


func _prepare() -> bool:
	head_anchor = _get_parent_physics_body(start_point)
	assert(not head_anchor == null)
	tail_anchor = _get_parent_physics_body(end_point)
	assert(not tail_anchor == null)
	
	_distance = start_point.global_transform.origin.distance_to(end_point.global_transform.origin)
	_turning_index = resolution / 2
	_calc_length()
	
	if resolution < 1:
		push_error("resolution cannot be less then one")
		return false
	
	if resolution > 2:
		var before_turning_count := _turning_index + 1
		var before_turning_length := ((before_turning_count + 0.5) * _joint_length + before_turning_count * segment_length)
		var after_turning_length := rope_length - before_turning_length
		
		if not _is_triangle(before_turning_length, after_turning_length, _distance):
			print(before_turning_length, ", ", after_turning_length, ", ", _distance)
			push_error("can not construct triangle")
			return false
	
	if _distance > rope_length:
		rope_length = _distance
		_calc_length()
		push_warning("rope is too short")
		return true
	
	if segment_length > _distance / resolution:
		print("segment_length:", segment_length)
		print("distance", _distance)
		print("_distance / resolution", _distance / resolution)
		push_error("segment is longer than distance")
		return false
	
	return true


func _calc_length():
	var joint_count := resolution + 1
	_joint_length = (rope_length - resolution * segment_length) / joint_count


func _generate():
	segments.clear()
	
	rope_mesh.path.curve.add_point(start_point.global_position)
	
	for i in resolution:
		var segment := _generate_segment(segment_length)
		segment.name = str(i)
		segment.visible = true
		add_child(segment)
		segments.push_back(segment)
		rope_mesh.path.curve.add_point(segment.global_position)
	
	rope_mesh.path.curve.add_point(end_point.global_position)
	rope_mesh.radius = radius
	
	_reposition()
	_add_joints()


func _generate_segment(length: float) -> RopeSegment:
	var segment: RopeSegment = RopeSegmentScene.instantiate()
	segment.radius = length / 2.0
	return segment


func _reposition():
	if segments.size() == 1:
		var segment: RopeSegment = segments[0]
		segment.global_transform.origin = middle_point
	
	elif segments.size() == 2:
		var first_segment: RopeSegment = segments[0]
		var last_segment: RopeSegment = segments[1]
		
		var dir: Vector3 = end_point.global_transform.origin - start_point.global_transform.origin
		var k1 = (_joint_length + 0.5 * segment_length) / rope_length
		var k2 = (2.0 * _joint_length + 1.5 * segment_length) / rope_length
		first_segment.global_transform.origin = start_point.global_transform.origin + k1 * dir
		last_segment.global_transform.origin = start_point.global_transform.origin + k2 * dir
	
	elif segments.size() > 2:
		var before_turning_count := _turning_index + 1
		var before_turning_length := ((before_turning_count + 0.5) * _joint_length + before_turning_count * segment_length)
		var after_turning_length := rope_length - before_turning_length
		
		_circle = Circle.new(start_point, before_turning_length, \
				end_point, after_turning_length)
		
		var theta = _rng.randf_range(0.0, 2 * PI)
		var turning_point := _circle.get_point(theta)
#		_turning_point_draw = turning_point
		
		for i in len(segments):
			var segment: RopeSegment = segments[i]
			if i <= _turning_index:
				var dir: Vector3 = turning_point - start_point.global_transform.origin
				var k: float = ((i + 1) * _joint_length + i * segment_length + 0.5 * segment_length) / before_turning_length
				segment.global_transform.origin = start_point.global_transform.origin + k * dir
			else:
				var dir: Vector3 = end_point.global_transform.origin - turning_point
				var k: float =  ((i - before_turning_count + 1) * _joint_length + segment_length) / after_turning_length
				segment.global_transform.origin = turning_point + k * dir


func _add_joints():
	var first_segment: RopeSegment = segments[0]
	var last_segment: RopeSegment = segments[resolution - 1]
	var first_joint = _generate_joint_between(head_anchor, first_segment)
	var last_joint = _generate_joint_between(last_segment, tail_anchor, 0)

	first_segment.add_child(first_joint)
	first_joint.global_transform.origin = start_point.global_transform.origin
	last_segment.add_child(last_joint)
	last_joint.global_transform.origin = end_point.global_transform.origin

	for i in len(segments):
		if segments.size() >= i + 2:
			var segment: RopeSegment = segments[i]
			var next_segment: RopeSegment = segments[i + 1]
			var joint = _generate_joint_between(segment, next_segment)
			segment.add_child(joint)
			var sphere_middle_point = segment.global_transform.origin + (next_segment.global_transform.origin - segment.global_transform.origin) * 0.5
			joint.global_transform.origin = sphere_middle_point


func _generate_joint_between(body_a: PhysicsBody3D, body_b: PhysicsBody3D, priority: int = 1) -> PinJoint3D:
	var joint := PinJoint3D.new()
	joint.set_node_a(body_a.get_path())
	joint.set_node_b(body_b.get_path())
	joint.set_solver_priority(priority)
	return joint


func _get_parent_physics_body(node: Node3D) -> PhysicsBody3D:
	while node and not node is PhysicsBody3D:
		node = node.get_parent()
	return node as PhysicsBody3D


func _is_triangle(a: float, b: float, c: float) -> bool:
	if a + b <= c:
		return false
	
	if a + c <= b:
		return false
	
	if b + c <= a:
		return false
	
	return true


func _physics_process(_delta):
	if _generated:
		_update_mesh()


func _update_mesh():
	rope_mesh.path.curve.set_point_position(0, start_point.global_position)
	rope_mesh.path.curve.set_point_position(
		rope_mesh.path.curve.point_count - 1,
		end_point.global_position
	)
	
	for i in len(segments):
		var segment: RopeSegment = segments[i]
		rope_mesh.path.curve.set_point_position(i + 1, segment.global_position)
