extends Node2D
class_name LightManager

@export var tile_layer : TileMapLayer
@export var tile_size : int = 64

@export var darkness : float = 0.75
@export var min_light_radius : int = 2
@export var max_light_radius: int = 6

# Holds light levels
var shadow_data : Dictionary

var current_player_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	# not sure why but the container needs to be offset for the tiles to be aligned.
	generate_shadow_data()
	await get_tree().create_timer(0.1).timeout
	global.player.moved.connect(update_light_map)
	update_light_map(Vector2i.ZERO)
	set_physics_process(true)

func _draw() -> void:
	for shadow in shadow_data:
		var offset_pos : Vector2 = shadow * tile_size
		var size : Vector2 = Vector2(tile_size,tile_size)
		var colour : Color = Color(0,0,0,shadow_data[shadow])
		
		draw_rect(Rect2(offset_pos,size),colour)

func generate_shadow_data() -> void:
	for tile in tile_layer.get_used_cells():
		shadow_data[tile] = darkness
	
func tile_exists(tile_pos : Vector2i) -> bool:
	var check : bool = shadow_data.has(tile_pos)
	return check

func set_tile_light_level(tile_position : Vector2i,light_level : float = darkness) -> void:
	if light_level > darkness:
		light_level = darkness
	# Update the light level dict
	shadow_data[tile_position] = light_level
	# then apply the update to the scene

# Function for setting light level to black
func clear_light_map() -> void:
	for tile in shadow_data:
		shadow_data[tile] = darkness
	queue_redraw()

func update_light_map(_n:Vector2i) -> void:
	clear_light_map()
	
	var player_pos : Vector2i = tile_layer.local_to_map(global.player.position)
	
	for x in range(player_pos.x - max_light_radius, player_pos.x + max_light_radius + 1):
		for y in range(player_pos.y - max_light_radius, player_pos.y + max_light_radius + 1):
			var tile_position = Vector2i(x, y)
			
			# if the tile position is not valid we continue
			if not tile_exists(tile_position): continue
			
			# check the distance of the tile to create a fall off value
			var distance : float = player_pos.distance_to(tile_position)
			
			if distance <= max_light_radius:
				# This needs to be replaced with checking boundaries function so we cant see
				# past walls.
				if true:
					var light_level : float = calculate_light_level(distance,min_light_radius,max_light_radius)
					set_tile_light_level(tile_position,light_level)
				else:
					set_tile_light_level(tile_position)
	
	queue_redraw()
	
func calculate_light_level(distance: float, min_distance: float, max_distance: float) -> float:
	var clamped_distance = clamp(distance, min_distance, max_distance)
	
	var scaled = (clamped_distance - min_distance) / (max_distance - min_distance)
	
	return scaled
