extends Node2D
class_name LightManager

@export var tile_layer: TileMapLayer
@export var subdivisions: int = 2  # Number of subdivisions for each tile
@export var default_light: Color
@export var darkness: float = 0.75
@export var light_radius: int = 2

# Dictionary to hold light levels
var shadow_data: Dictionary = {}
var light_data: Array[TileLightData] = []
var previous_position: Vector2i = Vector2i.ZERO  # To track previous player position
func _ready() -> void:
	# Initialize shadow data for used tiles with subdivisions
	var light_array: Array[Color] = []
	light_array.resize(pow(subdivisions, 2))
	light_array.fill(default_light)
	
	for tile in tile_layer.get_used_cells():
		shadow_data[tile] = TileLightData.new(tile, light_array.duplicate())
	await get_tree().process_frame  # Pause to ensure all elements are ready
	global.player.moved.connect(light_update)  # Connect player movement to light update
	light_update(Vector2.ZERO)  # Initial light update

func light_update(player_position: Vector2i) -> void:
	# Reset light data
	for tile_light in light_data:
		tile_light.subs.fill(default_light)
	light_data.clear()

	# Determine tiles within the light radius
	for x in range(player_position.x - light_radius * 2, player_position.x + light_radius * 2 + 1):
		for y in range(player_position.y - light_radius * 2, player_position.y + light_radius * 2 + 1):
			var tile_pos = Vector2i(x, y)
			if shadow_data.has(tile_pos):
				var tile_light_data = shadow_data[tile_pos]

				var it: int = 0
				for j in range(-subdivisions+1, subdivisions, 2):
					for k in range(-subdivisions+1, subdivisions, 2):
						# Sub-position offset within the tile based on subdivisions
						var sub_pos: Vector2 = Vector2(tile_pos) + Vector2(j, k) / float(pow(subdivisions, 2))
						
						# Calculate distance to player position
						var distance = max(1.0, sub_pos.distance_to(player_position))
						
						# Calculate intensity using a quadratic falloff
						var light_intensity = max(0.0, 1.0 - distance / light_radius)
						
						# Assign intensity to the specific sub-position
						tile_light_data.subs[it] = Color(1, 1, 1, light_intensity)
						it += 1
				light_data.append(tile_light_data)
	queue_redraw()

func _draw() -> void:
	var rect = tile_layer.get_used_rect()
	draw_rect(Rect2(rect.position * 128, rect.size * 128), default_light)
	for tile_light in light_data:
		var tile_pos = Vector2(tile_light.position * tile_layer.tile_set.tile_size)  # Convert tile position to screen position
		var tile_size = Vector2(tile_layer.tile_set.tile_size) / float(subdivisions)  # Adjust size for subdivisions
		
		# Draw each subdivision within the tile
		var it: int = 0
		for x in range(subdivisions):
			for y in range(subdivisions):
				var sub_pos = tile_pos + Vector2(x, y) * tile_size
				var color = tile_light.subs[it]
				it += 1
				draw_rect(Rect2(sub_pos, tile_size), color)

# Define a class to store tile light data
class TileLightData:
	var position: Vector2i
	var subs: Array[Color]

	func _init(_position: Vector2i, _subs: Array[Color]):
		position = _position
		subs = _subs
