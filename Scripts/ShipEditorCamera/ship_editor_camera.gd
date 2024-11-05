extends Camera2D
class_name ShipEditorCamera

@export_subgroup("Zoom values")
@export var current_zoom : Vector2 = Vector2(1.2,1.2)
@export var max_zoom : Vector2 = Vector2(2.0,2.0)
@export var min_zoom : Vector2 = Vector2(0.8,0.8)
@export_subgroup("Drag values")
@export var speed : float = 2.5
@export var smoothing : float = 15.0
@export var invert_x : bool = false
@export var invert_y : bool = false
var movement : Vector2 = Vector2.ZERO

var is_held : bool

func _ready() -> void:
	zoom = current_zoom

func _input(event: InputEvent) -> void:
	
	## Handles dragging the camera around
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			is_held = true
		elif event.is_released():
			is_held = false
	
	if event is InputEventMouseMotion and is_held:
		var motion : Vector2 = event.get_relative() * speed
		
		if invert_x:
			motion.x = -motion.x
		if invert_y:
			motion.y = -motion.y
		
		if motion:
			movement += motion
	
	# Handle zooming in and out.
	if event.is_pressed():
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				update_zoom("-",event.factor * 0.2)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				update_zoom("+",event.factor * 0.2)
	
func _physics_process(delta: float) -> void:
	position = lerp(position,movement,smoothing * delta)
	zoom = lerp(zoom,current_zoom,smoothing * delta)

func update_zoom(type : String,value : float) -> void:
	match type:
		"+":
			current_zoom += Vector2(value,value)
		"-":
			current_zoom -= Vector2(value,value)
	current_zoom = clamp(current_zoom,min_zoom,max_zoom)
