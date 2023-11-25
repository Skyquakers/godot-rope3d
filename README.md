# Godot Rope3D

Physical 3D rope based on `PinJoint3D` that interacts with `RigidBody3D`


[![Youtube Video](https://img.youtube.com/vi/cEQaXuW3KQQ/0.jpg)](https://www.youtube.com/watch?v=cEQaXuW3KQQ)



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
	rope.resolution = 6.0   # number of pinjoints
	rope.radius = 0.1
	
	var ok = rope.can_make()
	if ok:
		add_child(rope)
		rope.make()
```

## Rope Making Fails

Due to dynamic generating, there are many situations that `rope.make()` can raise errors

- The `rope_length` is shorter then distance between two `Node3D`s
- `resolution` cannot be less then one
- The size of segment is longer than the rope
- Two global positions of `Node3D` and the turning point position cannot constitude to a triangle, as shown in the figure below

![dynamic_rope_3](https://github.com/Skyquakers/godot-rope3d/assets/2919533/ae40f2dc-a15d-447a-aa93-d2d274ce63db)

If you want to make gameplays that allows player to create rope on the fly, make sure to check the `boolean` result of `rope.make()` or `rope.can_make()`

## Without Physics

If you do not need physics, you can simply instantiate a `RopeMesh` and operate the curve points of the child `Path3D`

`RopeMesh` is an `ImmediateMesh` that draws a 3d rope from `Path3D`


[verlet rope C#](https://godotengine.org/asset-library/asset/2308), `ImmediateMesh` rope with particle verlet integration simulation, is highly recommended if you don't need `RigidBody3D` interaction and use C# for your project.


# How it works

[Dynamic 3D Physical Rope in Godot](https://juryquinn.com/post/technology/2023-09-05)
