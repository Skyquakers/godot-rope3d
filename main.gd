extends Node3D

const RopeScene: PackedScene = preload("res://addons/rope3d/Rope3D.tscn")

@onready var start_point = $WhiteCapsule/Marker3D
@onready var end_point = $BlueCapsule/Marker3D


func _ready():
	var rope = RopeScene.instantiate()
	rope.start_point = start_point
	rope.end_point = end_point
	rope.rope_length = 6.0
	rope.resolution = 6.0
	rope.radius = 0.1
	
	var ok = rope.can_make()
	print(ok)
	if ok:
		add_child(rope)
		rope.make()
	
