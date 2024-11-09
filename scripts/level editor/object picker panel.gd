extends Panel

# Resources
const ObjectPicker     := preload("res://scenes/level editor/LE - Object Picker.tscn")
const ObjectPickerIcon := preload("res://scenes/level editor/LE - Object Picker Icon.tscn")
const tileset: TileSet  = preload("res://tileset.tres")


# Nodes
onready var placement_preview := get_parent().get_node("Crosshair")
onready var objpickers := $Scroll/Items
onready var map   := owner.get_node("Map")


# Variables
const MAX_ROW_LEN := 7
var pointer := Vector2.ZERO
var spawnables := []
var spawned_objects := []
enum ObjectType { Texture2D, Scene }

# Node functions
func _ready():
	add_object_ui("Basic Tiles", [
		{
			"object": Global.get_tile_texture("Block"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("Block Left"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("Block Middle"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("Block Right"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("45* stair"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("Something* stair"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("Dark"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		},
		{
			"object": Global.get_tile_texture("Moon"),
			"icon":   null,
			"type":   ObjectType.Texture2D
		}
	])
	add_object_ui("General Prefab Objects", [
		{
			"object": preload("res://scenes/Platform.tscn"),
			"icon":   null,
			"type":   ObjectType.Scene
		},
		{
			"object": preload("res://scenes/FakePlatform.tscn"),
			"icon":   null,
			"type":   ObjectType.Scene
		}
	])
	add_object_ui("Gameplay Logic Objects", [
		{
			"object": preload("res://scenes/Portal.tscn"),
			"icon":   null,
			"type":   ObjectType.Scene
		},
		{
			"object": preload("res://scenes/SugomaPlatform.tscn"),
			"icon":   null,
			"type":   ObjectType.Scene
		},
		{
			"object": preload("res://scenes/TasksDonePlatform.tscn"),
			"icon":   null,
			"type":   ObjectType.Scene
		}
	])

# TODO:
# FIX THE ROW THING, doesn't let me move the cursor right
# and stuff to select tiles

func _process(delta):
	# Messy code to handle input, idk how to make it better
	var objpicker_items = objpickers.get_child(pointer.y).get_node("Items")
	if Input.is_action_just_pressed("ui_up") and pointer.y - 1 >= 0:
		pointer.y -= 1
		objpickers.get_child(pointer.y).grab_focus()
		if pointer.x >= objpickers.get_child(pointer.y).get_node("Items").get_child_count():
			pointer.x = 0
		Global.player.refresh_placement_preview()
	elif Input.is_action_just_pressed("ui_down") and pointer.y + 1 < objpickers.get_child_count():
		pointer.y += 1
		objpickers.get_child(pointer.y).grab_focus()
		if pointer.x >= objpickers.get_child(pointer.y).get_node("Items").get_child_count():
			pointer.x = 0
		Global.player.refresh_placement_preview()
	if Input.is_action_just_pressed("ui_left") and pointer.x - 1 >= 0:
		pointer.x -= 1
		objpickers.get_child(pointer.y).grab_focus()
		Global.player.refresh_placement_preview()
	elif Input.is_action_just_pressed("ui_right") and pointer.x + 1 < objpicker_items.get_child_count():
		pointer.x += 1
		objpickers.get_child(pointer.y).grab_focus()
		Global.player.refresh_placement_preview()
	
	# Spawning of objects
	if Input.is_action_just_pressed("spawn_object") or Input.is_action_pressed("spawn_object"):
		var result = spawn_object(spawnables[pointer.y][pointer.x])
		print("spawned: ", "true" if result else "false")
	
	# Visual stuff
	for y in objpickers.get_child_count():
		var ychild = objpickers.get_child(y)
		var yselected = ychild.get_node("Selected")
		yselected.visible = (y == pointer.y)
		
		#for row in ychild.get_node("Items").get_children():
		#print("ROW: ", row)
		for x in ychild.get_node("Items").get_child_count():
			var xchild = ychild.get_node("Items").get_child(x)
			var xselected = xchild.get_node("Selected")
			xselected.visible = (yselected.visible and x == pointer.x)

# Public functions
func spawn_object(info: Dictionary, preview := false) -> bool:
	var new_obj_info: Dictionary = info.duplicate()
	if info.type == ObjectType.Texture2D:
		var inst := Sprite.new()
		inst.texture = info.object
		inst.rotation_degrees = Global.player.current_spawning_object.rotation
		if not preview:
			inst.position = Global.player.position
		
		for obj in spawned_objects:
			if obj.type != ObjectType.Texture2D:
				continue
			
			if Rect2(obj.instance.position, obj.object.get_size()).intersects(
				Rect2(inst.position, inst.texture.get_size())
			):
				return false
		if not preview:
			map.add_child(inst)
			new_obj_info["instance"] = inst
		else:
			placement_preview.add_child(inst)
	elif info.type == ObjectType.Scene:
		var inst: Node2D = info.object.instance()
		inst.pause_mode = PAUSE_MODE_STOP
		inst.rotation_degrees = Global.player.current_spawning_object.rotation
		if not preview:
			inst.position = Global.player.position
		
		if not preview:
			map.add_child(inst)
			new_obj_info["instance"] = inst
		else:
			placement_preview.add_child(inst)
	else:
		return false
	if not preview:
		spawned_objects.append(new_obj_info)
	return true
	
func add_object_ui(title: String, objects: Array):
	var objpicker: Control = ObjectPicker.instance()
	objpicker.get_node("Name").text = title
	
	var temp_data := []
	
	var rows: Container = objpicker.get_node("Items")
	
	for i in range(len(objects)):
#		var row: HBoxContainer = null
#		if i % MAX_ROW_LEN == 0:
#			row = HBoxContainer.new()
#			row.add_constant_override("separation", 6)
#			rows.add_child(row)
#		else:
#			row = rows.get_child(rows.get_child_count()-1)
		var object: TextureRect = ObjectPickerIcon.instance()
		if objects[i].icon != null:
			object.texture = objects[i].icon
		elif objects[i].type == ObjectType.Texture2D:
			object.texture = objects[i].object
		else:
			printerr("No object icon found (level editor UI)")
		rows.add_child(object)
		temp_data.append(objects[i])
	objpickers.add_child(objpicker)
	spawnables.append(temp_data)
	
