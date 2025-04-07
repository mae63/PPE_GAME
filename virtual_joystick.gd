extends Control

class_name VirtualJoystick

signal on_joystick_moved(vector: Vector2)
signal on_joystick_released

@export var joystick_size := 150.0
@export var dead_zone := 0.2

var _touch_index := -1
var _center_position: Vector2
var _current_vector := Vector2.ZERO
var _max_distance: float
var _active := false
var _dragging := false

@onready var _joystick_bg := $JoystickBG
@onready var _joystick_stick := $JoystickBG/JoystickStick

func _ready() -> void:
	_max_distance = joystick_size * 0.4
	_joystick_bg.custom_minimum_size = Vector2(joystick_size, joystick_size)
	_joystick_bg.size = Vector2(joystick_size, joystick_size)
	_center_position = _joystick_bg.size / 2
	_joystick_stick.position = _center_position
	_joystick_bg.modulate.a = 0.5  # Semi-transparent when inactive

func _input(event: InputEvent) -> void:
	if not _active:
		return
		
	if event is InputEventScreenTouch:
		if event.pressed:
			if _touch_index == -1 and _is_point_inside_joystick(event.position):
				_touch_index = event.index
				_dragging = true
				_joystick_bg.modulate.a = 0.8  # More visible when active
		else:
			if event.index == _touch_index:
				_reset_joystick()
				
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			var new_pos = event.position - _joystick_bg.global_position
			var vector = (new_pos - _center_position).limit_length(_max_distance)
			_joystick_stick.position = _center_position + vector
			
			_current_vector = vector / _max_distance
			if _current_vector.length() < dead_zone:
				_current_vector = Vector2.ZERO
				
			emit_signal("on_joystick_moved", _current_vector)
			
func _reset_joystick() -> void:
	_touch_index = -1
	_dragging = false
	_current_vector = Vector2.ZERO
	_joystick_stick.position = _center_position
	_joystick_bg.modulate.a = 0.5
	emit_signal("on_joystick_released")

func _is_point_inside_joystick(point: Vector2) -> bool:
	var dist = point.distance_to(_joystick_bg.global_position + _center_position)
	return dist <= joystick_size / 2

func activate() -> void:
	_active = true
	show()
	
func deactivate() -> void:
	_active = false
	hide()
	_reset_joystick()

func get_joystick_vector() -> Vector2:
	return _current_vector 