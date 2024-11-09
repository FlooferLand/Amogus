extends TouchScreenButton

const size = Vector2(256, 256)

var value: Vector2

# Public variables
var just_pressed = false
var just_released = false

func _process(delta):
	just_released = false
	value = lerp(value, Vector2(0, 0), 0.1)

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if is_pressed():
			value = calculate_move_vector(event.position)
		elif just_pressed == true:
			just_released = true
		just_pressed = event is InputEventScreenTouch and is_pressed()

func calculate_move_vector(event_position):
	var texture_center = position + (size / 2)
	return (event_position - texture_center).normalized()
