extends Node2D
class_name PlayerNode

## Number of actions the player can take in a single turn
@export var Actions: int = 2

## Movement speed of the player
@export var speed: float = 200.0

## Flag to determine if the player is controlled by a player character
@export var pc: bool = true

## Current input direction from user input
var input_direction: Vector2 = Vector2.ZERO

## Current cell position of the player in the grid
var current_cell: Vector2i

## Target cell position for movement
var target_cell: Vector2

## Array to hold the calculated path for movement
var path: Array = []

## Current index in the path array
var path_index: int = 0

## Flag indicating if the player is currently moving
var moving: bool = false

## Array to hold the positions to highlight on the path
var highlight_path: PackedVector2Array = []

## Reference to the interactable object currently selected by the player
var selected_object: InteractableObj

## Called when the node is added to the scene
func _ready() -> void:
	# Initialize global player and pathfinder variables
	global.player = self
	global.pathfinder = AStarGrid2D.new()
	global.map = get_parent().get_parent().get_child(0)
	
	# Set the pathfinder's region and cell size
	global.pathfinder.region = global.map.get_used_rect()
	global.pathfinder.cell_size = Vector2.ONE * 128
	global.pathfinder.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	global.pathfinder.update()

	# Mark solid points in the pathfinder based on tile data
	for pos in global.map.get_used_cells():
		if global.map.get_cell_tile_data(pos).get_custom_data("Col") == 0:
			global.pathfinder.set_point_solid(pos)

## Handles unhandled input events, such as mouse clicks
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Get the cell position based on mouse click location
		var cell_position = global.map.local_to_map(get_global_mouse_position())
		if cell_position in global.map.get_used_cells() and global.map.get_cell_tile_data(cell_position).get_custom_data("Col") == 1:
			# Calculate and highlight the path to the clicked position
			highlight_path = global.calculate_path(position, get_global_mouse_position())
			# Only set path if it is valid and within action limits
			if highlight_path.size() - 1 <= Actions:
				path = highlight_path 

func _process(delta: float) -> void:
	if pc:
		# Continuously update highlight path for player character
		highlight_path = global.calculate_path(position, get_global_mouse_position())
		_process_path_following(delta) # Move along the path
		_update_highlight_path() # Update visual highlights
	else:
		_process_tile_movement(delta) # Handle movement for non-player characters

## Processes following the calculated path
func _process_path_following(delta: float) -> void:
	if path.size() > path_index:
		var target_position = global.map.map_to_local(path[path_index])
		# Move toward the target position
		global_position = global_position.move_toward(target_position, delta * speed)
		queue_redraw() # Schedule a redraw to update visuals

		# Check if the player has reached the target position
		if position.distance_to(target_position) < speed * delta:
			position = target_position
			path_index += 1 # Move to the next point in the path
	else:
		_reset_path() # Reset path if end of path is reached

## Resets the path and index when movement is complete
func _reset_path() -> void:
	path.clear() # Clear the path array
	path_index = 0 # Reset index to start

## Updates the visual highlights of the path
func _update_highlight_path() -> void:
	if pc and highlight_path.size() > 0:
		queue_redraw() # Schedule the draw function to update the highlights

## Handles movement based on tile grid for non-player characters
func _process_tile_movement(delta: float) -> void:
	if global_position.distance_to(global.map.map_to_local(target_cell)) < 1.0: # Check if at target
		input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		current_cell = global.map.local_to_map(global_position)
		# Check if the next cell is not solid
		if global.pathfinder.is_point_solid(current_cell + Vector2i(input_direction)) == false:
			target_cell = current_cell + Vector2i(input_direction)
		
	# Move towards the target cell if it is valid
	if global.map.get_cell_tile_data(target_cell) and global.map.get_cell_tile_data(target_cell).get_custom_data("Col") == 1:
		var target_position = global.map.map_to_local(target_cell)
		global_position = global_position.move_toward(target_position, delta * speed) # Smooth movement

func _draw() -> void:
	if pc and highlight_path.size() > 0:
		for pos in highlight_path:
			# Determine the color based on path validity
			var draw_color = Color(1, 1, 0, 1) if highlight_path.find(pos) <= Actions else Color(1, 0, 0, 1)
			draw_circle(global.map.map_to_local(pos) - position, 20, draw_color)
		
		var final_color = Color(1, 1, 0, 1) if highlight_path.size() - 1 <= Actions else Color(1, 0, 0, 1)
		draw_rect(Rect2(global.map.map_to_local(highlight_path[highlight_path.size() - 1]) - (Vector2.ONE * 62.5) - position, Vector2(128, 128)), final_color, false, 10)
