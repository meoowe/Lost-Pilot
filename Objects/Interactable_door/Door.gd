extends InteractableObj
class_name InteractableDoor
@export var GUI:Control
var door_state : bool = false
@export var anim:AnimatedSprite2D
func _ready() -> void:
	priority = 2
	interact()
func _process(delta: float) -> void:
	if (global.player.position - position).length() < 200:
		if global.player.selected_object != null:
			if global.player.selected_object.priority >= priority && global.player.selected_object != self:
				GUI.visible = false
				return
		GUI.grab_focus()
		global.player.selected_object = self
		GUI.visible = true
	else:
		if global.player.selected_object != null:
			if global.player.selected_object == self:
				global.player.selected_object = null
		GUI.visible = false
func interact() -> void:
	door_state = !door_state
	print(door_state)
	match door_state:
		true:
			global.pathfinder.set_point_solid(global.map.local_to_map(position), true)
			anim.play_backwards("open")
			priority = 2
		false:
			global.pathfinder.set_point_solid(global.map.local_to_map(position), false)
			anim.play("open")
			priority = 1
