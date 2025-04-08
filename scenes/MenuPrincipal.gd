extends Control

@onready var start_button = $TextureRect/StartButton
@onready var hard_mode_button = $TextureRect/HardModeButton
@onready var quit_button = $TextureRect/QuitButton
@onready var hard_mode_label = $HardModeLabel


func _ready():
	start_button.pressed.connect(_on_start_pressed)
	hard_mode_button.pressed.connect(_on_hard_mode_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/quiz.tscn")  # Charger la scène du quiz

func _on_hard_mode_pressed():
	GameManager.set_hard_mode(true)  # Activer le mode difficile
	hard_mode_label.text = "Hard Mode: ON"
	

func _on_quit_pressed():
	get_tree().quit()  # Quitter le jeu
