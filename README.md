# Godot Rope3D

Physical 3D rope that interacts with `RigidBody3D`


[![Youtube Video](https://img.youtube.com/vi/dr0yJTLtpkI/0.jpg)](https://www.youtube.com/watch?v=dr0yJTLtpkI)



# Installation

Via asset library

# Usage

## GUI

- Instantiate child scene. Adding child node will not work because Rope3D scene has children
- click Rope3D
- Select start point, end point, adjust other values
- Reference the `Rope3D` node in code, call `rope.make()` when you need it

## Code

```gdscript
const RopeScene: PackedScene = preload("res://addons/rope3d/Rope3D.tscn")

@onready var start_point = $RigidBody/Node3D
@onready var end_point = $AnotherRigidBody/AnotherNode3D


func _ready():
	var rope = RopeScene.instantiate()
	rope.start_point = start_point
	rope.end_point = end_point
	rope.rope_length = 6.0
	rope.resolution = 6.0   # number of sphere rigidbody3ds
	rope.radius = 0.1
	
	var ok = rope.can_render()
	if ok:
		add_child(rope)
		rope.make()
```
