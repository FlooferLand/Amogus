extends Node2D

# Nodes
onready var camera    := $"Cam"
onready var grid      := get_parent().get_node("Grid")
onready var joystick  := $"Cam/UI/Touchscreen/Joystick"
onready var object_picker := $"Cam/UI/Level Editor UI/Object Picker Panel"
onready var placement_preview := $"Cam/UI/Level Editor UI/Crosshair"

# Variables
const MOVE_SPEED := 7
const OBJ_GRID_ROT := 45
var grid_snapping := true
var current_spawning_object := {
	"rotation": 0,
	"size": Vector2(1.0, 1.0)
} # Transform details about the next object that's being placed

# Helper functions
func crossplatform_input(desktop: String, touchscreen: bool) -> Dictionary:
	if touchscreen and Global.device_has_touchscreen():
		return {
			"held":     true,
			"pressed":  true,
			"released": true,
			"any":      true
		}
	else:
		return {
			"held":     Input.is_action_pressed(desktop),
			"pressed":  Input.is_action_just_pressed(desktop),
			"released": Input.is_action_just_released(desktop),
			"any":      Input.is_action_pressed(desktop) or Input.is_action_just_pressed(desktop) or Input.is_action_just_released(desktop)
		}

# Node functions
func _ready():
	Global.player = self

func _physics_process(delta):
	# Movement keymaps
	var key_left = crossplatform_input(
		"player_move_left",
		joystick.output.x < 0
	)
	var key_right = crossplatform_input(
		"player_move_right",
		joystick.output.x > 0
	)
	var key_up = crossplatform_input(
		"player_jump",
		joystick.output.y < 0.3
	)
	var key_down = crossplatform_input(
		"player_crouch",
		joystick.output.y > 0.3
	)
	
	# Editor keymaps
	var key_toggle_gridsnap = crossplatform_input(
		"toggle_grid",
		false
	)
	var key_rotate_l = crossplatform_input(
		"rotate_left",
		false
	)
	var key_rotate_r = crossplatform_input(
		"rotate_right",
		false
	)
	
	# Grid snap toggle
	if key_toggle_gridsnap.pressed:
		grid_snapping = !grid_snapping
		grid.draw_alpha = 2 if grid_snapping else 1
		position = Vector2(
			QuickMafs.snappy_boi(position.x),
			QuickMafs.snappy_boi(position.y)
		)
		current_spawning_object.rotation = QuickMafs.snappy_boi(current_spawning_object.rotation, 45)
		grid.update()
		refresh_placement_preview()
	
	# Movement
	if not grid_snapping:
		if key_left.held:
			position.x -= MOVE_SPEED
		elif key_right.held:
			position.x += MOVE_SPEED
		
		if key_up.held:
			position.y -= MOVE_SPEED
		elif key_down.held:
			position.y += MOVE_SPEED
	else:
		if key_left.pressed:
			position.x -= Global.tile_size
			grid.target_offset.x = Global.tile_size
		elif key_right.pressed:
			position.x += Global.tile_size
			grid.target_offset.x = -Global.tile_size
		
		if key_up.pressed:
			position.y -= Global.tile_size
			grid.target_offset.y = Global.tile_size
		elif key_down.pressed:
			position.y += Global.tile_size
			grid.target_offset.y = -Global.tile_size
		
		grid._offset = lerp(grid._offset, grid.target_offset, 0.25)
		if grid._offset.abs().ceil() >= grid.target_offset.abs().ceil():
			grid._offset       = Vector2.ZERO
			grid.target_offset = Vector2.ZERO
	
	# Object rotation
	if not grid_snapping:
		if key_rotate_l.held:
			current_spawning_object.rotation -= 1
			refresh_placement_preview()
		elif key_rotate_r.held:
			current_spawning_object.rotation += 1
			refresh_placement_preview()
	else:
		if key_rotate_l.pressed:
			current_spawning_object.rotation -= OBJ_GRID_ROT
			refresh_placement_preview()
		elif key_rotate_r.pressed:
			current_spawning_object.rotation += OBJ_GRID_ROT
			refresh_placement_preview()
	
	#print(current_spawning_object.rotation)
	
	# If player moves, update the grid
	if grid._offset != grid.target_offset or (key_left.any or key_right.any or key_up.any or key_down.any):
		grid.update()
	
# Public functions
func refresh_placement_preview():
	for child in placement_preview.get_children():
		child.queue_free()
	object_picker.spawn_object(
		object_picker.spawnables[object_picker.pointer.y][object_picker.pointer.x],
		true
	)
