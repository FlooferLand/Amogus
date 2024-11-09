extends KinematicBody2D

# Scenes
onready var Checkpoint := preload("res://scenes/Checkpoint.tscn")
onready var Dust := preload("res://scenes/Dust.tscn")

# Animation presets
onready var anim_dababy := preload("res://animations/Playerus Dababy.tres")
onready var sfx_array_dababy_hah := [preload("res://audio/DaBaby Ha Short.wav"), preload("res://audio/DaBaby Ha.wav")]

# Velocity
var velocity := Vector2(0, 0)
const velocity_increase := 6
const max_velocity := 1040

# Horizontal speed
const initial_speed := 100

# Jumping and vertical movement
const initial_jump_height := 1000
const jump_height_increase := 5
const original_gravity := 35
const feet_offset := Vector2(0, 40)
var   debug_flight_speed := 50
var   gravity := original_gravity
var   starting_position := Vector2(415, 330)
var   initial_camera_zoom := Vector2.ZERO

# Player state stuff
var attempts := 0
var dead := false
var has_moved := false
var can_move := true
var can_jump := true
var can_crouch := true
var debug_power_mode := false
var checkpoints_enabled := false
var last_checkpoint: Object = null
var floor_lift_frame_counter := 0
var was_on_floor_last_frame := false

# Sligthly helping touchscreen users as the controls are tougher there
const control_difficulty_helper_touchscreen = 10
var control_difficulty_helper = 0

# Nodes
onready var camera            := $"Cam"
onready var sprite            := $"Sprite"
onready var jump_sfx          := $"Cam/Jump SFX"
onready var fail_sfx          := $"Cam/Fail SFX"
onready var death_sfx         := $"Cam/Death SFX"
onready var win_sfx           := $"Cam/Win SFX"
onready var teleportus_sfx    := $"Cam/Teleportus SFX"
onready var joystick          := $"Cam/UI/Touchscreen/Joystick"
onready var jump_button       := $"Cam/UI/Touchscreen/Jump Button"
onready var crouch_button     := $"Cam/UI/Touchscreen/Crouch Button"
onready var restart_button    := $"Cam/UI/Touchscreen/Restart Button"
onready var checkpoint_button := $"Cam/UI/Touchscreen/Checkpoint Button"
onready var pause_button      := $"Cam/UI/Touchscreen/Pause Button"
onready var attempt_counter   := $"Cam/UI/Indicators/Attempt Counter"
onready var speedrun_timer    := $"Cam/UI/Indicators/Speedrun Timer"
onready var mode_indicator    := $"Cam/UI/Indicators/Mode Indicator"

# Crossplatform movement (touchscreen and other stuff)
func crossplatform_input(desktop: bool, touchscreen: bool) -> bool:
	if not can_move:
		return false
	if desktop:
		control_difficulty_helper = 0
		has_moved = true
		return true
	elif touchscreen and Global.device_has_touchscreen():
		control_difficulty_helper = control_difficulty_helper_touchscreen
		has_moved = true
		return true
	return false

func _spawn_dust():
	var inst = Dust.instance()
	inst.position = position + feet_offset
	inst.visible = false
	inst.rotation_degrees = rad2deg(get_floor_angle()) - (90 + (90 * (2 if (get_slide_count() > 1) else 1)))
	
	get_parent().add_child(inst)
	if is_on_floor() or floor_lift_frame_counter < 2:
		inst.visible = true
		

func _ready():
	Global.final_time = 0
	Global.speedrun_timer = speedrun_timer
	Global.player = self
	
	# Setting default camera zoom
	initial_camera_zoom = camera.zoom
	camera.zoom = Vector2.ONE * 0.25
	
	# Handle player death (respawning and stuff)
	death_sfx.connect("finished", self, "reset")
	
	# Enabling checkpoints for debug builds (allows for easier debugging)
	if Global.debug_mode():
		checkpoints_enabled = true
	else:
		position = starting_position
	
	# Easy mode (dababy lol)
	if Global.dababy_mode:
		sprite.frames = anim_dababy
		mode_indicator.visible = true
		mode_indicator.text = "DABABY MODE"
		mode_indicator.add_color_override("font_color", Color.red)
		checkpoints_enabled = true
	else:
		checkpoint_button.visible = false
		mode_indicator.visible = false

func _physics_process(delta):
	var left_just_pressed := crossplatform_input(
		Input.is_action_just_pressed("player_move_left"),
		joystick.output.x < 0 and joystick.just_pressed
	)

	var holding_left := crossplatform_input(
		Input.is_action_pressed("player_move_left"),
		joystick.output.x < 0
	)
	
	var right_just_pressed := crossplatform_input(
		Input.is_action_just_pressed("player_move_right"),
		joystick.output.x > 0 and joystick.just_pressed
	)
	
	var holding_right := crossplatform_input(
		Input.is_action_pressed("player_move_right"),
		joystick.output.x > 0
	)

	var jump_just_pressed := can_jump and crossplatform_input(
		Input.is_action_just_pressed("player_jump"),
		jump_button.just_pressed
	)

	var jump_just_released := can_jump and crossplatform_input(
		Input.is_action_just_released("player_jump"),
		jump_button.just_released
	)

	var holding_jump := can_jump and crossplatform_input(
		Input.is_action_pressed("player_jump"),
		jump_button.holding
	)
	
	var crouch_just_pressed := can_crouch and crossplatform_input(
		Input.is_action_just_pressed("player_crouch"),
		crouch_button.just_pressed
	)
	
	var holding_crouch := can_crouch and crossplatform_input(
		Input.is_action_pressed("player_crouch"),
		crouch_button.holding
	)
	
	var restart_just_pressed := crossplatform_input(
		Input.is_action_just_pressed("restart"),
		restart_button.just_pressed
	)
	
	var checkpoint_just_pressed := crossplatform_input(
		Input.is_action_just_pressed("set_checkpoint"),
		checkpoint_button.just_pressed
	)
	
	var debug_powers_just_activated := Global.debug_mode() and crossplatform_input(
		Input.is_action_just_pressed("toggle_debug_powers"),
		false
	)
	
	# Manual restart
	if restart_just_pressed:
		die()
	
	# Debug power mode
	if debug_powers_just_activated:
		debug_power_mode = !debug_power_mode
	
	if debug_power_mode:
		gravity = 0.0
		if holding_left:
			velocity.x -= debug_flight_speed
		elif holding_right:
			velocity.x += debug_flight_speed
		if holding_crouch:
			velocity.y += debug_flight_speed
		elif holding_jump:
			velocity.y -= debug_flight_speed
		velocity = Vector2(
			lerp(velocity.x, 0, 0.05),
			lerp(velocity.y, 0, 0.05)
		)
		velocity = move_and_slide(velocity, Vector2.UP, true)
		return
	
	# Crouching
	if crouch_just_pressed:
		velocity = velocity / 12
	
	if holding_crouch:
		scale.y = 0.5
		gravity = original_gravity * 1.8
	else:
		if not is_on_ceiling():
			scale.y = 1.0
			gravity = original_gravity
	
	# Les gooo
	var easiness_multiplier = (1.8 if Global.dababy_mode else 1.0)
	
	# Checkpoint system
	if checkpoints_enabled && checkpoint_just_pressed && not dead:
		if last_checkpoint != null:
			last_checkpoint.free()
			last_checkpoint = null
		
		var checkpoint = Checkpoint.instance()
		checkpoint.position = position
		last_checkpoint = checkpoint
		get_parent().add_child(checkpoint)
	
	# Start speedrun timer when player moves
	if has_moved and speedrun_timer.stopped:
		speedrun_timer.start()
	
	# While the player *just pressed* a button
	if left_just_pressed:
		velocity.x = -initial_speed * easiness_multiplier
	elif right_just_pressed:
		velocity.x = initial_speed * easiness_multiplier
	
	# Wall jumping
	var walljump := \
		  ((1 if test_move(transform, Vector2(-25, 0)) else 0) \
		- (1 if test_move(transform, Vector2(25,  0)) else 0)) \
		if Global.Features.WallJump in Global.features else 0
	if jump_just_pressed and not is_on_floor() and walljump != 0:
		jump_sfx.play()
		velocity.x = (initial_speed * 6) * walljump
		velocity.y = -((initial_jump_height * 1.5) + (control_difficulty_helper * 6))
	
	# Initial jump
	var if_enabled_pogo: bool = (holding_jump and is_on_floor() and floor_lift_frame_counter > 0) \
		if Global.Features.Pogo in Global.features \
		else false
	if (jump_just_pressed or if_enabled_pogo) and not is_on_ceiling():
		if is_on_floor() or floor_lift_frame_counter < 6:
			velocity.y = -(initial_jump_height + (control_difficulty_helper * 6))
			if Global.dababy_mode:
				jump_sfx.stream = sfx_array_dababy_hah[randi() % 2]
			_spawn_dust()
			jump_sfx.play()
		elif walljump == 0:
			fail_sfx.play()
	
	# Handling the floor lift frame counter
	if is_on_floor():
		floor_lift_frame_counter = 0
	else:
		floor_lift_frame_counter += 1
	
	if is_on_floor() or jump_just_released:
		jump_sfx.stop()
		fail_sfx.stop()
	
	# Landing
	if not was_on_floor_last_frame and is_on_floor() and get_floor_angle() == 0 and not holding_jump and not jump_just_pressed:
		_spawn_dust()
		velocity.y = 0
		was_on_floor_last_frame = false
	
	was_on_floor_last_frame = is_on_floor()
	
	# Increase velocity while the player is running left/right
	if abs(velocity.x) < (max_velocity * (1.2 if Global.dababy_mode else 1.0)):
		if holding_left:
			velocity.x -= velocity_increase * easiness_multiplier
		elif holding_right:
			velocity.x += velocity_increase * easiness_multiplier
	
	# Decrease velocity if the player isn't running
	if not holding_left and not holding_right:
		velocity.x = lerp(velocity.x, 0, 0.025 if not Global.dababy_mode else 0.08)
	
	# Invert velocity if the player bumps into a wall (haha funny)
	if Global.Trolls.Bouncer in Global.we_do_a_little_bit_of_trolling:
		if is_on_wall():
			velocity.x = (-1000 if holding_right else 1000 if holding_left else 0)
			jump_sfx.volume_db = 20
			jump_sfx.play()
		elif not is_on_wall() and not jump_sfx.playing and jump_sfx.volume_db > 0:
			jump_sfx.volume_db = 0
	
	# Increase velocity while the player is jumping
	if abs(velocity.y) < max_velocity:
		if holding_jump:
			velocity.y -= jump_height_increase + (abs(velocity.x) / (90 - control_difficulty_helper))
	else:
		velocity.y = lerp(velocity.y, 0, 0.1)
	
	# Gravity
	velocity.y += gravity * (0.0 if is_on_floor() else 1.0) # * (0.0 if get_slide_count() else 1.0)
	
	# Applying movement
	var snap := Vector2.ZERO if jump_just_pressed else Vector2.DOWN
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	
	# UI
	attempt_counter.text = "Attempts so far: " + str(attempts)
	
	# Zoom animations
	if dead:
		camera.zoom = lerp(camera.zoom, camera.zoom - Vector2(0.1, 0.1), 0.05)
	else:
		var yes = ((initial_camera_zoom * 0.85) + Vector2(
			(abs(velocity.x) / (max_velocity)) * 0.15,
			(abs(velocity.x) / (max_velocity)) * 0.15
		).abs())
		camera.zoom = lerp(camera.zoom, yes, 0.03)
	
	# Stop any other animation than the death one from playing
	# when the player dies
	if dead: return
	
	# Animation
	if holding_left or holding_right:
		sprite.play("walk")
	else:
		sprite.play("idle")
	
	if not is_on_floor():
		sprite.play("air")

func reset():
	#get_tree().reload_current_scene()
	has_moved = false
	velocity = Vector2(0, 0)
	dead = false
	camera.zoom = initial_camera_zoom
	if last_checkpoint != null:
		position = last_checkpoint.position
		teleportus_sfx.play()
		last_checkpoint.queue_free()
		last_checkpoint = null
	else:
		speedrun_timer.reset()
		position = starting_position

func die():
	if debug_power_mode or dead:
		return
	dead = true
	attempts += 1
	sprite.play("death")
	death_sfx.play()
