extends Node2D
class_name Room

@export var walls : Dictionary = {"north" : true,"east" : true,"south":true,"west":true}

@export var north : Sprite2D
@export var east : Sprite2D
@export var south : Sprite2D
@export var west : Sprite2D

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	
	var data : TileMapLayer = GameManager.ship_editor.layer
	# Register its self because its the only way to get neighbours.
	GameManager.ship_editor.register_block(data.local_to_map(global_position),self)
	
	#print(data.local_to_map(global_position))

# Updates the walls in the room
func set_walls() -> void:
	for wall in walls:
		if walls[wall] == false:
			match wall:
				"north":
					north.visible = false
				"east":
					east.visible = false
				"south":
					south.visible = false
				"west":
					west.visible = false

# function for checking if its connecting to other rooms.
func check_room_exists(data : TileMapLayer) -> void:
	var tile_position : Vector2i = data.local_to_map(global_position)
	var neighbors : Array[Vector2i] = data.get_surrounding_cells(tile_position)
	
	#print("Tile pos (%s)" % tile_position)

	# Need to check each direction
	for neighbour in neighbors:
		var cell : Room = GameManager.ship_editor.get_block(neighbour)
		
		if cell == null: continue
		
		var direction : Vector2i = neighbour - tile_position
		
		match direction:
			Vector2i(0,-1): # North
				walls["north"] = false
			Vector2i(1,0): # East
				walls["east"] = false
			Vector2i(0,1): # South
				walls["south"] = false
			Vector2i(-1,0): # West
				walls["west"] = false
