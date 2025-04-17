extends Control

# ----------------------------------------------------------
# Variables et ressources
# ----------------------------------------------------------
# Tableau contenant les textures des personnages
var characters = []
# Index du personnage actuellement affiché
var current_character_index = 0

# Références aux noeuds (assurez-vous que les chemins correspondent à votre arborescence)
@onready var character_display = $CharacterDisplay
@onready var left_arrow = $LeftArrow
@onready var right_arrow = $RightArrow
@onready var ready_button = $ReadyButton

func _ready():
	# Charger les textures des personnages dans le tableau
	# Remplacez les chemins par ceux de vos fichiers
	characters.append( preload("res://logo/picture/perso.jpg") )
	characters.append( preload("res://logo/picture/perso2.jpg") )
	characters.append( preload("res://logo/picture/perso3.jpg") )
	# Vous pouvez ajouter autant de personnages que nécessaire…

	# Initialiser l'affichage avec le premier personnage
	_update_character_display()

	# Connecter les signaux des boutons
	left_arrow.pressed.connect(_on_LeftArrow_pressed)
	right_arrow.pressed.connect(_on_RightArrow_pressed)
	ready_button.pressed.connect(_on_ReadyButton_pressed)


	# (Optionnel) Si vous souhaitez désactiver la flèche gauche au début
	_update_arrows_visibility()

# ----------------------------------------------------------
# Fonctions utilitaires
# ----------------------------------------------------------

# Met à jour l'affichage du personnage en fonction de l'index courant
func _update_character_display():
	if characters.size() > 0:
		character_display.texture = characters[current_character_index]

# Permet de gérer la visibilité ou l’état des flèches si besoin (ex. désactiver la gauche si sur le premier élément)
func _update_arrows_visibility():
	# Ici, par exemple, désactiver la flèche gauche si le personnage actuel est le premier
	left_arrow.disabled = current_character_index <= 0
	# Désactiver la flèche droite si le personnage actuel est le dernier
	right_arrow.disabled = current_character_index >= characters.size() - 1

# ----------------------------------------------------------
# Fonctions de gestion des boutons
# ----------------------------------------------------------

# Action quand on appuie sur la flèche gauche
func _on_LeftArrow_pressed():
	# Vérifier qu'il y a un personnage précédent
	if current_character_index > 0:
		current_character_index -= 1
		_update_character_display()
		_update_arrows_visibility()

# Action quand on appuie sur la flèche droite
func _on_RightArrow_pressed():
	# Vérifier qu'il y a un personnage suivant
	if current_character_index < characters.size() - 1:
		current_character_index += 1
		_update_character_display()
		_update_arrows_visibility()

# Action quand on appuie sur le bouton Ready
func _on_ReadyButton_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menue.tscn")


func _on_ready_button_pressed() -> void:
	pass # Replace with function body.
