extends Button

func _on_Button_pressed():
	# Load the PackedScene resource
	var packed_scene = load("res://my_scene.tscn")
# Instance the scene
	var my_scene = packed_scene.instance()
	add_child(my_scene)
	get_tree().change_scene("res://my_scene.tscn")
	pass