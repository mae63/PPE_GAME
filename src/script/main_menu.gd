extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scene/main_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scene/option_screen.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
