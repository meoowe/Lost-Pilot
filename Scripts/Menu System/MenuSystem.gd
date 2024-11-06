extends Node
class_name MenuSystem

@export var disable : bool = false

# Add values to this enum for add extra menus, also InGame menu is supposed to be a blank scene
# Health bar, xp level labels should be its own canvas layer and not attached to the menu manager
enum Keys {InGame,MainMenu,Paused,Settings,Credits}
# Storing the menus in a dict using the menu keys as a way to index it.
var menus : Dictionary = {}
# Current menu is the actual scene
var current_menu : Control
var current_menu_key : Keys
# Previous menus is how we load previous menus so the current menu doesnt need
# to have information about previous menus
var previous_menus : Array = []
# Where we instance the current menu
var menu_container : CanvasLayer

func _ready() -> void:
	
	if disable: return
	
	set_up_menu_container()
	
	add_menu(Keys.InGame,"res://Menus/InGame/in_game_menu.tscn")
	add_menu(Keys.Paused,"res://Menus/PauseMenu/pause_menu.tscn")
	add_menu(Keys.MainMenu,"res://Menus/MainMenu/main_menu.tscn")
	add_menu(Keys.Settings,"res://Menus/Settings/settings_menu.tscn")
	add_menu(Keys.Credits,"res://Menus/CreditsMenu/credits_menu.tscn")
	
	load_menu(Keys.MainMenu)

func add_menu(key : Keys , menu_path : String) -> void:
	menus[key] = load(menu_path)

func load_menu(key : Keys) -> void:
	# Should wait one frame before loading the next menu, to avoid any unwanted issue.
	call_deferred("deferred_menu_load",key)

func load_previous_menu() -> void:
	# Delete the last menu in the previous menu array and load it
	previous_menus.pop_back()
	call_deferred("deferred_menu_load",previous_menus[-1])

func deferred_menu_load(key : Keys) -> void:
	
	# Stop attempt as menu does not exist.
	if not menus.has(key): assert(true,"No menu found!")
	
	# If the previous menu array is empty we add the first menu,
	# elif the last menu isnt the same one as the current one we add it
	if previous_menus.size() == 0:
		previous_menus.append(key)
	elif previous_menus[-1] != key:
		previous_menus.append(key)
	
	# Queue free current menu if its not null.
	if current_menu:
		current_menu.queue_free()
	
	# Get the next menu from the menus dict
	var next_menu : PackedScene = menus[key]
	
	# Set the current menu by instancing the next menu
	current_menu = next_menu.instantiate()
	# Add it to the menus container
	menu_container.add_child(current_menu)
	# Set the menu manager to the menu so it can do menu changes
	current_menu.set_menu_manager(self)
	
	# Set the game to paused if a menu pauses the game
	get_tree().paused = current_menu.is_paused


func set_up_menu_container() -> void:
	# If we dont have a place to store the menus we need to create it
	if not menu_container:
		var canvas : CanvasLayer = CanvasLayer.new()
		canvas.name = "Menu Container"
		add_child(canvas)
		menu_container = canvas
