extends Node2D

@onready var logo_sprite: Sprite2D = $LogoSprite
@onready var logo_animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_menu: Control = $UILayer/StartMenu

var has_shown_logo = false

func _ready():
	logo_sprite.visible = true
	start_menu.visible = false

	if !has_shown_logo:
		has_shown_logo = true
		var initial_color = logo_sprite.modulate
		initial_color.a = 0.0
		logo_sprite.modulate = initial_color

		var target_color = logo_sprite.modulate
		target_color.a = 1.0
		var tween = create_tween()
		tween.tween_property(logo_sprite, "modulate", target_color, 3.0)
		tween.tween_callback(func():
			await get_tree().create_timer(2.0)
			start_menu.visible = true
			logo_sprite.visible = false
		)
