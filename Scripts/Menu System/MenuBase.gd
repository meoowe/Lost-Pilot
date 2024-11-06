extends Control
class_name MenuBase

var menu_manager : MenuSystem
@export var is_paused : bool = false

func set_menu_manager(_menu_manager : MenuSystem) -> void:
	menu_manager = _menu_manager

# Duplicate this scene and create a new script that you extend from this.
