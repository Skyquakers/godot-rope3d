@tool
extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_render()


func _render():
	# Clean up before drawing.
	mesh.clear_surfaces()
	# Begin draw.
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	# Prepare attributes for add_vertex.
	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	mesh.surface_add_vertex(Vector3(-1, -1, 0))

	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(0, 1))
	mesh.surface_add_vertex(Vector3(-1, 1, 0))

	mesh.surface_set_normal(Vector3(0, 0, 1))
	mesh.surface_set_uv(Vector2(1, 1))
	mesh.surface_add_vertex(Vector3(1, 1, 0))

	# End drawing.
	mesh.surface_end()
