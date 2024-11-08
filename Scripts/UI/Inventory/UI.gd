extends CanvasLayer

var holding_item = null

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Hotbar.tooltip_change()
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
	if event.is_action_pressed("hotkey1"):
		PlayerInventory.change_active_item_slot(0)
	if event.is_action_pressed("hotkey2"):
		PlayerInventory.change_active_item_slot(1)
	if event.is_action_pressed("hotkey3"):
		PlayerInventory.change_active_item_slot(2)
	if event.is_action_pressed("hotkey4"):
		PlayerInventory.change_active_item_slot(3)
	if event.is_action_pressed("hotkey5"):
		PlayerInventory.change_active_item_slot(4)
	if event.is_action_pressed("hotkey6"):
		PlayerInventory.change_active_item_slot(5)
	if event.is_action_pressed("hotkey7"):
		PlayerInventory.change_active_item_slot(6)
	if event.is_action_pressed("hotkey8"):
		PlayerInventory.change_active_item_slot(7)
		

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
