extends MenuBase


func _on_play_pressed() -> void:
	GameManager.spawn_scene(GameManager.Keys.SpaceStation)
	menu_manager.load_menu(menu_manager.Keys.Play)

func _on_settings_pressed() -> void:
	menu_manager.load_menu(menu_manager.Keys.Settings)


func _on_quit_pressed() -> void:
	get_tree().quit()
