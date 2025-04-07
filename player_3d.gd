extends CharacterBody3D

@export_group("Camera")
@export_range(0.0,1.0) var mouse_sensitivity :=0.25 

@export_group("Movement")
@export var move_speed := 2.0
@export var acceleration :=5.0 
@export var rotation_speed := 12.0 
@export var jump_impulse :=12.0

var _camera_input_direction := Vector2.ZERO 
var _last_movement_direction := Vector3.BACK 
var _gravity := -30.0
var _last_valid_position := Vector3.ZERO
var _joystick_input := Vector2.ZERO
var _using_mobile_controls := false

@onready var _camera_pivot: Node3D = %CameraPivot 
@onready var _camera: Camera3D = %Camera3D 
@onready var _skin = %SophiaSkin
@onready var _floor_ray: RayCast3D = $FloorRay
@onready var _mobile_controls = $MobileControlsCanvas/MobileControls if has_node("MobileControlsCanvas/MobileControls") else null

func _ready():
	if OS.has_feature("mobile"):
		_using_mobile_controls = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
		
	# Configure le rayon pour détecter le sol
	_floor_ray.target_position = Vector3(0, -1.0, 0)
	_floor_ray.enabled = true
	_last_valid_position = position
	
	# Connecter les signaux des contrôles mobiles s'ils existent
	if _mobile_controls:
		_mobile_controls.connect("joystick_moved", Callable(self, "_on_joystick_moved"))
		_mobile_controls.connect("camera_rotated", Callable(self, "_on_camera_rotated"))
	
func _input(event:InputEvent)-> void:
	if not _using_mobile_controls:
		if event.is_action_pressed("ui_cancel"):     #TOUCHE ESC 
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED :
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
			else : 
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

func _unhandled_input(event: InputEvent)-> void: 
	if not _using_mobile_controls:
		var is_camera_motion := (
			event is InputEventMouseMotion and 
			Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
			)
		if is_camera_motion: 
			_camera_input_direction = event.screen_relative * mouse_sensitivity 
		
func is_on_path() -> bool:
	if _floor_ray.is_colliding():
		var collider = _floor_ray.get_collider()
		# Vérifie si le collider est dans le groupe "path"
		if collider is StaticBody3D and collider.is_in_group("path"):
			return true
	return false

func _on_joystick_moved(direction: Vector2) -> void:
	_joystick_input = direction

func _on_camera_rotated(rotation_amount: Vector2) -> void:
	_camera_input_direction = rotation_amount
		
func _physics_process(delta: float) -> void : 
	_camera_pivot.rotation.x += _camera_input_direction.y * delta  
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, deg_to_rad(-75),deg_to_rad(75))
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta 
	_camera_input_direction = Vector2.ZERO
	
	# Récupérer l'input de mouvement (clavier ou joystick)
	var raw_input := Vector2.ZERO
	if _using_mobile_controls:
		raw_input = _joystick_input
	else:
		raw_input = Input.get_vector("move_left","move_right","move_up","move_down")
	
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x 
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	# Gestion du mouvement et de la position
	var target_velocity = Vector3.ZERO
	
	if is_on_path():
		# Sur le chemin : mouvement normal et sauvegarde de la position
		target_velocity = move_direction * move_speed
		_last_valid_position = position
		velocity.y = 0  # Pas de mouvement vertical sur le chemin
	else:
		# Hors du chemin : retour à la dernière position valide
		position = _last_valid_position
		velocity = Vector3.ZERO
	
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	
	move_and_slide()
	
	if move_direction.length() > 0.2 and is_on_path():
		_last_movement_direction = move_direction
		
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)
	
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	if ground_speed > 0.0 and is_on_path():
		_skin.move()
	else:
		_skin.idle()
