extends Control

@onready var left_button: Button = $LeftButton
@onready var right_button: Button = $RightButton
@onready var viewport: Viewport = $Viewport
@onready var character_name_label: Label = $CharacterNameLabel
@onready var confirm_button: Button = $ConfirmButton
var character_data = []
var selected_character_index = 0
var current_model_node: Node3D # To store the instantiated model

func _ready():
	load_character_data()
	setup_scene()
	load_character_model(selected_character_index) # Load the initial model
	update_character_name_label()
	confirm_button.connect("pressed", _on_confirm_button_pressed)

func load_character_data():
	if ResourceLoader.exists("res://character_data.gd"):
		character_data = load("res://character_data.gd").characters
	else:
		character_data = [
			{
				"name": "Knight",
				"scene": "res://sohpia_skin/model/sophia.glb",
				"description": "A strong melee fighter.",
			},
			{
				"name": "Mage",
				"scene": "res://scenes/character/cute_chibi_fox.glb",
				"description": "A powerful magic user.",
			}
		]

func setup_scene():
	left_button.connect("pressed", _on_left_button_pressed)
	right_button.connect("pressed", _on_right_button_pressed)
	# Set up the Viewport's camera (you might need to adjust these values)
	var camera = Camera3D.new()
	camera.transform = Transform3D(Basis.looking_at(Vector3(0, 0, 2), Vector3(0, 1, 0)), Vector3(0, 1, 5))  # Position the camera
	viewport.add_child(camera)

func load_character_model(index: int):
	# Remove the previous model if it exists
	if is_instance_valid(current_model_node):
		current_model_node.queue_free()

	var character_scene = load(character_data[index].scene)
	current_model_node = character_scene.instantiate()
	viewport.add_child(current_model_node)
	# You might need to adjust the model's position and scale here

func update_character_name_label():
	character_name_label.text = character_data[selected_character_index].name

func _on_left_button_pressed():
	selected_character_index = (selected_character_index - 1 + character_data.size()) % character_data.size() #loop
	load_character_model(selected_character_index)
	update_character_name_label()

func _on_right_button_pressed():
	selected_character_index = (selected_character_index + 1) % character_data.size() #loop
	load_character_model(selected_character_index)
	update_character_name_label()

func _on_confirm_button_pressed():
	var selected_character = character_data[selected_character_index]
	var character_scene = load(selected_character.scene)
	var character_instance = character_scene.instantiate()
	get_tree().change_scene_to_file("res://your_main_game_scene.tscn") # Change
	var main_scene = get_tree().current_scene
	main_scene.add_child(character_instance)
	# Pass any data to the character instance if needed
