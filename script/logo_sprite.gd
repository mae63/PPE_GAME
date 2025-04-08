extends Node2D

@onready var logo_sprite: Sprite2D = $LogoSprite
@onready var logo_animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_menu: Control = $UILayer/StartMenu

var has_shown_logo = false

func _ready():
	logo_sprite.visible = true # Initially hide the logo
	start_menu.visible = false # Initially hide the start menu

	if !has_shown_logo:
		has_shown_logo = true
		logo_sprite.modulate.a = 0.0 # Ensure logo is initially transparent
		logo_sprite.visible = true # Make the logo node visible
		start_menu.visible = true # Show the start menu after the delay
