extends Node

# Base write handler
func _write(text: String):
	if SaveFile.data["enable_logger"]:
		print(text)

# Info print
func write_info(info: String, location: String = ""):
	_write(
		"info@[%s]\t%s" % [location, info]
	)

# Warn print
func write_warning(warning: String, location: String = ""):
	_write(
		"warning@[%s]\t%s" % [location, warning]
	)
	
# Error print
func write_error(error: String, location: String = ""):
	_write(
		"error@[%s]\t%s" % [location, error]
	)
	
