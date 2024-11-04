extends Node2D
class_name ShipEditor

@export var layer : TileMapLayer
# Since we are using scenes we cant access it through the tile map.
var blocks : Dictionary

func _ready() -> void:
	GameManager.ship_editor = self
	await get_tree().create_timer(0.2).timeout
	generate_rooms()

func register_block(index : Vector2i,block : Room) -> void:
	blocks[index] = block

func get_block(index : Vector2i) -> Room:
	if not blocks.has(index) : return null
	
	return blocks[index]

func generate_rooms() -> void:
	for index : Vector2i in layer.get_used_cells():
		blocks[index].check_room_exists(layer)
		blocks[index].set_walls()
