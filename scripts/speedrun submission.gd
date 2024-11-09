extends RichTextLabel

func _meta_clicked(meta):
	if OS.shell_open(meta) != OK:
		bbcode_text = "[center]Couldn't open the link in your web browser, so here's the URL instead (you can select it): %s" % meta
	
func _ready():
	bbcode_text = "[center]Submit your run %s if you want it to be marked as an official speedrun" % Global.bb_link(GameInfo.speedrun_submission_url, "here")
	connect("meta_clicked", self, "_meta_clicked")
