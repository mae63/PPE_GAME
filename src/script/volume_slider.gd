extends Slider

@export var bus_name: String

func _ready() -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		printerr("Audio bus '" + bus_name + "' not found!")
		return
	
	value_changed.connect(_on_value_changed)
	
	# Get initial volume from bus and set slider
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		printerr("Audio bus '" + bus_name + "' not found!")
		return
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
