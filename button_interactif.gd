extends Node3D

@export var interaction_distance := 2.0
@export var target_scene: String = "res://scenes/quiz.tscn"
@export var interaction_key: String = "e"

var player = null
var can_interact = false
var interaction_label: Label3D = null

func _ready():
	add_to_group("interactive")
	
	# Créer une Area3D pour détecter le joueur
	var area = Area3D.new()
	add_child(area)
	
	# Ajouter une CollisionShape3D à l'Area3D
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = interaction_distance
	collision.shape = shape
	area.add_child(collision)
	
	# Connecter les signaux
	area.body_entered.connect(_on_area_3d_body_entered)
	area.body_exited.connect(_on_area_3d_body_exited)
	
	# Créer un label d'indication avec billboard activé
	interaction_label = Label3D.new()
	interaction_label.text = "Appuyez sur E pour interagir"
	interaction_label.position = Vector3(0, 1.5, 0)  # Au-dessus du bouton
	interaction_label.visible = false
	interaction_label.name = "InteractionLabel"
	
	# Configuration pour que le texte soit toujours face à la caméra
	interaction_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED  # Le texte fait toujours face à la caméra
	interaction_label.no_depth_test = true  # Le texte est toujours visible même à travers les objets
	interaction_label.modulate = Color(1, 1, 1, 0.9)  # Légèrement transparent
	interaction_label.font_size = 32  # Taille du texte
	interaction_label.outline_size = 2  # Contour pour meilleure lisibilité
	
	add_child(interaction_label)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		can_interact = true
		player = body
		print("Joueur à proximité du bouton")
		
		if interaction_label:
			interaction_label.visible = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		can_interact = false
		player = null
		print("Joueur s'est éloigné du bouton")
		
		if interaction_label:
			interaction_label.visible = false

func _input(event):
	if can_interact and event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			_activate_button()

func _activate_button():
	if player:
		# Animation simple (rotation)
		var tween = create_tween()
		tween.tween_property(self, "rotation:y", rotation.y + PI, 0.5)
		
		print("Bouton activé ! Chargement de la nouvelle scène...")
		
		# Attendre la fin de l'animation avant de changer de scène
		await tween.finished
		
		# Libérer la souris avant de charger la nouvelle scène
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		# Charger la nouvelle scène
		get_tree().change_scene_to_file(target_scene)
