extends Camera2D

# --- CONFIGURAÇÕES ---
@export_group("Movimento")
@export var move_speed: float = 600.0  
@export var pan_speed: float = 1.0     

@export_group("Zoom")
@export var zoom_step: float = 0.1    
@export var min_zoom: float = 0.1      
@export var max_zoom: float = 5.0      


var _is_dragging: bool = false

func _process(delta: float) -> void:
	_handle_keyboard_move(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_is_dragging = event.pressed
			
	elif event is InputEventMouseMotion and _is_dragging:
		position -= event.relative / zoom

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_at_point(1 + zoom_step, get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_at_point(1 - zoom_step, get_global_mouse_position())

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_PAGEUP:
			_zoom_at_point(1 + zoom_step, get_global_mouse_position())
		elif event.keycode == KEY_PAGEDOWN:
			_zoom_at_point(1 - zoom_step, get_global_mouse_position())

func _handle_keyboard_move(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
	
		var adjusted_speed = move_speed / zoom.x
		position += direction * adjusted_speed * delta

func _zoom_at_point(zoom_change: float, focus_point: Vector2) -> void:
	var mouse_before = focus_point
	
	var new_zoom = zoom * zoom_change
	
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	zoom = new_zoom
	
	var mouse_after = get_global_mouse_position()
	
	position += (mouse_before - mouse_after)
