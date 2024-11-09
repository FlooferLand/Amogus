extends CheckButton

# Public vars
export(String) var id = ""

# Node functions
func _ready():
	if id == "":
		printerr("Ya forgot to add an ID to a toggle setting")
	pressed = SaveFile.data[id]

func _toggled(button_pressed):
	SaveFile.save_setting(id, button_pressed)

