extends MenuBase


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	menu_manager.load_menu(menu_manager.Keys.MainMenu)


func _on_resume_pressed() -> void:
	menu_manager.load_previous_menu()
