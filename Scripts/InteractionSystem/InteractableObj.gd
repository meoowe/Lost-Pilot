extends Node2D
class_name InteractableObj

# Used for checking if this interactable obj is blocking the grid cell.
var is_blocking : bool = true
var priority:int = 0
# Override function
func interact() -> void:
	pass
