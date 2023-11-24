extends RigidBody3D
class_name RopeSegment

var radius := 0.5

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collisionshape: CollisionShape3D = $CollisionShape3D


func _ready():
	var mesh: SphereMesh = mesh_instance.mesh
	var shape: SphereShape3D = collisionshape.shape
	
	mesh.radius = radius
	mesh.height = radius * 2.0
	
	shape.radius = radius
