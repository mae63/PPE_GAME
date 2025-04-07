extends CanvasLayer

signal joystick_moved(direction: Vector2)
signal camera_rotated(rotation_amount: Vector2)

@export var camera_sensitivity := 0.25
@export var double_tap_jump := true

@onready var _joystick := $TouchControls/VirtualJoystick
@onready var _camera_control_area := $TouchControls/CameraControlArea

var _camera_touch_index := -1
var _last_camera_position := Vector2.ZERO
var _last_tap_time := 0.0
var _tap_count := 0

func _ready() -> void:
	if OS.has_feature("mobile"):
		show()
	else:
		hide()
		return
	
	_joystick.activate()
	_joystick.connect("on_joystick_moved", Callable(self, "_on_joystick_moved"))

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	# Gestion des contrôles de caméra par glissement
	if event is InputEventScreenTouch:
		if event.pressed:
			# Vérifier si le toucher est dans la zone de contrôle de caméra
			if _is_point_in_camera_area(event.position) and _camera_touch_index == -1:
				_camera_touch_index = event.index
				_last_camera_position = event.position
				
				# Gestion du double tap pour sauter
				if double_tap_jump:
					var current_time = Time.get_ticks_msec() / 1000.0
					if current_time - _last_tap_time < 0.3:
						_tap_count += 1
						if _tap_count >= 2:
							# Double tap détecté - implémenter le saut ici
							# Exemple : get_tree().call_group("player", "jump")
							_tap_count = 0
					else:
						_tap_count = 1
					_last_tap_time = current_time
		else:
			if event.index == _camera_touch_index:
				_camera_touch_index = -1
	
	# Déplacement de la caméra
	elif event is InputEventScreenDrag:
		if event.index == _camera_touch_index:
			var delta = event.position - _last_camera_position
			_last_camera_position = event.position
			
			# Inverser l'axe X pour une rotation plus intuitive
			delta.x = -delta.x
			delta *= camera_sensitivity
			
			emit_signal("camera_rotated", delta)

func _is_point_in_camera_area(point: Vector2) -> bool:
	var rect = _camera_control_area.get_global_rect()
	return rect.has_point(point)

func _on_joystick_moved(direction: Vector2) -> void:
	emit_signal("joystick_moved", direction) 