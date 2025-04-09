extends Node3D

const TILE_SIZE := 1.0 
const HEX_TILE : PackedScene = preload("res://scenes/HexTile.tscn")

@export_range (2, 20) 
var grid_size: int =10 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_grid()
	
	
func _generate_grid():
	for x in range (grid_size) : 
		for y in range(grid_size):
			var tile_coordinates := Vector2()
			tile_coordinates.x = x * TILE_SIZE * cos(deg_to_rad(30))
			tile_coordinates.y = y * TILE_SIZE * 0.75
			if y % 2 != 0 : 
				tile_coordinates.x += TILE_SIZE * cos(deg_to_rad(30))/2
			var tile = HEX_TILE.instantiate()
			add_child(tile) 
			tile.translate(Vector3(tile_coordinates.x,0,tile_coordinates.y))
			tile_coordinates.y += TILE_SIZE 
