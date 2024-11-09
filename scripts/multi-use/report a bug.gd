extends Button

func _pressed():
	OS.shell_open(GameInfo.bug_submission_url)
