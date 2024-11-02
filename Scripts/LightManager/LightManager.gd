extends Node2D
class_name LightManager

@export var tile_layer: TileMapLayer
@export var cell_size: int = 16  # Size of each mini-grid cell in pixels
@export var default_light: Color
@export var darkness: float = 0.75
@export var light_radius: int = 2  # Radius in tile grid units

# Dictionary to hold light levels on the mini-grid
var mini_grid: Dictionary = {}
var light_data: Array[Vector2i] = []  # Stores positions of cells affected by light
var previus_pos: Vector2
func _ready() -> void:
	initialize_mini_grid()
func _process(delta: float) -> void:
	if previus_pos != floor(global.player.position / cell_size):
		light_update(Vector2i.ZERO)
		previus_pos = floor(global.player.position / cell_size)
func initialize_mini_grid() -> void:
	# Set up each cell in mini_grid based on tile_layer cells
	for tile in tile_layer.get_used_cells():
		for x in range(-tile_layer.tile_set.tile_size.x, tile_layer.tile_set.tile_size.x, cell_size):
			for y in range(-tile_layer.tile_set.tile_size.y, tile_layer.tile_set.tile_size.y, cell_size):
				var cell_pos = tile*(tile_layer.tile_set.tile_size/cell_size) + Vector2i(Vector2(x, y) / cell_size)
				mini_grid[cell_pos] = default_light  # Initialize each cell with the default light level

func light_update(_n: Vector2i) -> void:
	var player_pos: Vector2 = global.player.position
	# Clear previous light data
	for pos in light_data:
		mini_grid[pos] = default_light  # Reset cells to default light level
	light_data.clear()

	# Determine cells within the light radius and apply light levels
	var cell_center_pos = floor(player_pos / cell_size)  # Adjust to use cell_size for proper scaling
	for x in range(-light_radius, light_radius):
		for y in range(-light_radius, light_radius ):
			var cell_pos = Vector2i(cell_center_pos) + Vector2i(x, y)  # Directly calculate the affected cell position
			if mini_grid.has(cell_pos):
				var distance = max(1.0, cell_pos.distance_to(cell_center_pos))  # Distance to the center cell
				var light_intensity = max(0.0, 1.0 - distance / float(light_radius))

				# Ensure light intensity does not exceed bounds
				light_intensity = clamp(light_intensity, 0.0, 1.0)
				
				# Update the cell light level and add to light_data
				mini_grid[cell_pos] = Color(1, 1, 1, light_intensity)  # Set the light color with intensity
				light_data.append(cell_pos)  # Store the position in light_data

	queue_redraw()  # Request a redraw of the scene

func _draw() -> void:
	var rect = tile_layer.get_used_rect()
	draw_rect(Rect2(rect.position * 128, rect.size * 128), default_light)
	# Draw each affected cell with its corresponding light level
	print(light_data.size())
	for pos in light_data:
		if mini_grid.has(pos):  # Ensure the position exists in mini_grid before drawing
			var cell_pos = pos * cell_size  # Convert to pixel coordinates
			draw_rect(Rect2(cell_pos, Vector2(cell_size, cell_size)), mini_grid[pos])  # Draw the light effect
