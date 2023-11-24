@tool
extends MeshInstance3D
class_name RopeMesh


@export var path: Path3D
@export var section_circle_resolution := 50
@export var radius := 0.5
@export var segment_count := 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_render()


func _render():
	var baked_points := path.curve.get_baked_points()
	if baked_points.size() < 2:
		return
	
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in (len(baked_points) - 1):
		var circle_points := _generate_cross_section_circle_points(baked_points[i], baked_points[i + 1])
		if i < len(baked_points) - 2:
			var next_circle_points := _generate_cross_section_circle_points(baked_points[i + 1], baked_points[i + 2])
			_draw_quad_between_circle_points(circle_points, next_circle_points)
	
	mesh.surface_end()


func _generate_cross_section_circle_points(point: Vector3, next_point: Vector3) -> PackedVector3Array:
	var points := PackedVector3Array()
	var dir := next_point - point
	var right := dir.cross(Vector3.UP).normalized()
	var up := right.cross(dir).normalized()
	
	for i in section_circle_resolution:
		var phi = 2.0 * PI * float(i) / float(section_circle_resolution)
		var local_point := Vector3(sin(phi) * radius, cos(phi) * radius, 0.0)
		var global_point := point + right * local_point.x + up * local_point.y
		points.push_back(global_point)
	
	return points


func _draw_quad_between_circle_points(circle_points: PackedVector3Array, next_circle_points: PackedVector3Array):
	for i in section_circle_resolution:
		var j := (i + 1) % section_circle_resolution
		
		# First triangle
		var i_normal := -1.0 * (circle_points[i] - circle_points[j]).cross(next_circle_points[i] - circle_points[i]).normalized()
		mesh.surface_set_normal(i_normal)
		mesh.surface_add_vertex(circle_points[i])
		
		var next_i_normal := -1.0 * (circle_points[i] - next_circle_points[i]).cross(next_circle_points[i] - next_circle_points[j]).normalized()
		mesh.surface_set_normal(next_i_normal)
		mesh.surface_add_vertex(next_circle_points[i])
		
		var next_j_normal := -1.0 * (circle_points[j] - next_circle_points[j]).cross(next_circle_points[i] - next_circle_points[j]).normalized()
		mesh.surface_set_normal(next_j_normal)
		mesh.surface_add_vertex(next_circle_points[j])
		
		# Second triangle
		mesh.surface_set_normal(i_normal)
		mesh.surface_add_vertex(circle_points[i])
		
		mesh.surface_set_normal(next_j_normal)
		mesh.surface_add_vertex(next_circle_points[j])
		
		var j_normal := -1.0 * (circle_points[i] - circle_points[j]).cross(next_circle_points[j] - circle_points[j]).normalized()
		mesh.surface_set_normal(j_normal)
		mesh.surface_add_vertex(circle_points[j])
