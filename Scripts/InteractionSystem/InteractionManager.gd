extends Node2D
class_name InteractionManager

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	
	if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		var cell_position = global.map.local_to_map(get_global_mouse_position())
		if cell_position in global.map.get_used_cells():
			print(global.map.get_cell_tile_data(cell_position).get_custom_data("Interactable"))
			check_interactable(cell_position)



func check_interactable(cell_position : Vector2) -> void:
	var cell : TileData = global.map.get_cell_tile_data(cell_position)
	var cell_data : Array = cell.get_custom_data("Interactable")
	
	# if the array is empty it is not an interactable
	# in the future we would need another way of detecting interactables
	# for example enemies wont be a tile but a scene.
	if cell_data.is_empty(): return
	
	# First index is the type of interactable
	# the second index is for custom data that interactable might have.
	var interactable_type : String = cell_data[0]
	
	# Handle each unique interaction here
	match interactable_type:
		"door":
			match cell_data[1]:
				"closed":
					cell_data[1] = "opened"
					cell.set_custom_data("Col",1)
				"opened":
					cell_data[1] = "closed"
					cell.set_custom_data("Col",0)
	# For some reason when changing the custom data for Col it resets the player position
