extends Control



func _on_resume_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn") 


func _on_options_pressed() -> void:
	var option_scene = load("res://scenes/option_screen.tscn").instantiate()
	get_tree().root.add_child(option_scene)
	option_scene.set_previous_scene(get_tree().current_scene.scene_file_path)


func _on_exit_game_pressed() -> void:
	get_tree().quit() # Replace with function body.
