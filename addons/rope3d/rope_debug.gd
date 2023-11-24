extends Node

@export var rope: Node3D

var rigidbodies := []
var joints := []


func _ready():
	await get_tree().create_timer(1.0).timeout
	for child in rope.get_children():
		if child is PhysicsBody3D:
			rigidbodies.push_back(child)
			for grand_child in child.get_children():
				if grand_child is Joint3D:
					joints.push_back(grand_child)


func _process(delta):
	for i in len(joints):
		var joint: PinJoint3D = joints[i]
		var body_a: PhysicsBody3D = joint.get_node(joint.get_node_a())
		var body_b: PhysicsBody3D = joint.get_node(joint.get_node_b())
		
		DDD.draw_line_3d(body_a.global_transform.origin, joint.global_transform.origin, Color.RED)
		DDD.draw_line_3d(body_b.global_transform.origin, joint.global_transform.origin, Color.GREEN)
