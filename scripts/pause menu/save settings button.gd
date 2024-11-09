extends Button

func _pressed():
	SaveFile.write_settings_to_disk()
