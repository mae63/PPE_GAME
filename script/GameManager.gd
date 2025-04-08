extends Node


var is_hard_mode = false  # Mode normal par défaut

func set_hard_mode(value: bool):
	is_hard_mode = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
