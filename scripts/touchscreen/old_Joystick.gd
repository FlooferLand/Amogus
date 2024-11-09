extends TouchScreenButton

# Thanks to Gonkee for most of the code!

export var radius = Vector2(80, 80)
export var boundary = 80  # Outer-circle radius

var ongoing_drag = -1
const return_acceleration = 20
const threshold = 15

var _just_pressed = 0
var just_pressed = false
var just_released = false

func _process(delta):
	if _just_pressed == 0:
		just_pressed = true
	
	if ongoing_drag == -1:
		var pos_difference = (Vector2(0, 0) - radius) - position
		position += pos_difference * return_acceleration * delta
		just_released = false
		_just_pressed = 0

func get_button_pos():
	return position + radius

func _input(event):
	if event is InputEventScreenDrag \
	or (event is InputEventScreenTouch and event.is_pressed()):
		var event_dist_from_center = (event.position - get_parent().global_position).length()
		
		_just_pressed += 1
		if event_dist_from_center <= boundary * global_scale.x or event.get_index() == ongoing_drag:
			set_global_position(event.position - radius * global_scale)
			
			if get_button_pos().length() > boundary:
				set_position(get_button_pos().normalized() * boundary - radius)
			
			ongoing_drag = event.get_index()
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		just_released = true
		
	
func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
	return Vector2(0, 0)
