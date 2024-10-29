extends Node2D
class_name LightManager

@onready var shadow_tile : PackedScene = preload("res://Scenes/ShadowTile/ShadowTile.tscn")
@export var tile_layer : TileMapLayer
@export var tile_size : int = 64

@export var darkness : float = 0.75
@export var max_light_radius: int = 6
@export var light_falloff: float = 0.1

# Not sure why but the container needs to be offset to align with the tilemap
@export var shadow_container : Node2D

# Holds light levels
var shadow_data : Dictionary
# Holds the scenes
var shadow_scenes : Dictionary

var current_player_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	set_physics_process(false)
	# not sure why but the container needs to be offset for the tiles to be aligned.
	shadow_container.position = Vector2(tile_size * 0.5,tile_size * 0.5)
	generate_shadow_data()
	instance_shadows()
	await get_tree().create_timer(0.1).timeout
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if current_player_pos != global.player.position:
		update_light_map()
		current_player_pos = global.player.position

func generate_shadow_data() -> void:
	for tile in tile_layer.get_used_cells():
		shadow_data[tile] = darkness

func instance_shadows() -> void:
	for shadow in shadow_data:
		var offset_pos : Vector2 = shadow * tile_size
		var _shadow_scene : Sprite2D = shadow_tile.instantiate()
		
		shadow_container.add_child(_shadow_scene)
		_shadow_scene.position = offset_pos
		shadow_scenes[shadow] = _shadow_scene
		
func tile_exists(tile_pos : Vector2i) -> bool:
	var check : bool = shadow_data.has(tile_pos)
	return check

func set_tile_light_level(tile_position : Vector2i,light_level : float = 1) -> void:
	# Update the light level dict
	shadow_data[tile_position] = light_level
	# then apply the update to the scene
	shadow_scenes[tile_position].set_modulate(Color(1,1,1,shadow_data[tile_position]))
	# = shadow_data[tile_position]

# Function for setting light level to black
func clear_light_map() -> void:
	print("Clearing light map")
	for tile in shadow_data:
		shadow_data[tile] = darkness
	
	for shadow_tile in shadow_scenes:
		shadow_scenes[shadow_tile].set_modulate(Color(1,1,1,shadow_data[shadow_tile]))

func update_light_map() -> void:
	clear_light_map()
	print("Updated light map")
	var player_pos : Vector2i = global.player.position / tile_size
	
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
					var light_level = clamp((distance * light_falloff) - 1.0, 0.0, 1.0)
					set_tile_light_level(tile_position,light_level)
				else:
					set_tile_light_level(tile_position)
