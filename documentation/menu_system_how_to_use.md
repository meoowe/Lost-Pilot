# How To Use Menu Manager#

1. First in the `menu_system.gd` script, add an enum value for your new menu
2. Then copy and paste the menu template `(res://Scenes/MenuTemplate.tscn)`
3. Rename it to your new menu and also extend the script attached to the menu template
4. Back into the menu system script use the `add_menu()` function to add your new menu. Use the other added menus as an example.
5. In your new menu create buttons for transitioning to other menus
by using
```gdscript
menu_manager.load_menu(menu_manager.key.NextMenu)
```
if you want to go back to a previous menu use 
```gdscript
menu_manager.load_previous_menu()
```

> [!NOTE]
> If the menu is supposed to pause game execution, enable `is_paused` to stop the game.
> Also ensure the process mode is set to `always` so the menu works when the game is paused.
