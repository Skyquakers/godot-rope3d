@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Rope3D", "Node3D", preload("./rope3d.gd"), null)
	print_debug("rope3d loaded sucessfully")

func _exit_tree():
	remove_custom_type("Rope3D")
	print_debug("rope3d un-loaded sucessfully")
