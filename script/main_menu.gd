extends Control

signal hard_mode_changed(hard_mode) # Signal pour envoyer le mode difficile

var is_hard_mode = false # Mode normal par défaut

func _on_start_pressed() -> void:
	hard_mode_changed.emit(is_hard_mode) # Envoie le mode difficile à la scène du quiz
	get_tree().change_scene_to_file("res://scenes/ile/map.tscn")
	
func _on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/option_screen.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_hard_mode_pressed() -> void:
	is_hard_mode = !is_hard_mode
	$Label.text = str(is_hard_mode)

func _on_choose_carac_pressed() -> void:
	pass # Replace with function body.
