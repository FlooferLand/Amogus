extends HSplitContainer

# Public vars
export(String) var id = ""

# Nodes
onready var label:  Label  = $Text
onready var slider: Slider = $Slider

# Node functions
func _ready():
	slider.connect("value_changed", self, "_value_changed")
	if id == "":
		printerr("Ya forgot to add an ID to a slider setting")
	print("data: ", SaveFile.data)
	print("id:   ", id)
	slider.value = SaveFile.data[id]

func _value_changed(value: float):
	SaveFile.save_setting(id, value)
