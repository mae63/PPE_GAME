extends Node3D

@export var main_scene: String = "res://map.tscn"

func _ready():
	# Connecter le bouton de retour
	var return_button = $ReturnButton
	if return_button:
		return_button.pressed.connect(_on_return_button_pressed)

func _input(event):
	# Retour à la scène principale avec la touche Echap
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_return_to_main_scene()

func _on_return_button_pressed():
	_return_to_main_scene()

func _return_to_main_scene():
	get_tree().change_scene_to_file(main_scene) 
