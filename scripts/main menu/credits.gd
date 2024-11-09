extends RichTextLabel

func meta_clicked(meta):
	if typeof(meta) == TYPE_STRING and meta.length() > 0:
		if OS.shell_open(meta) != OK:
			OS.alert("Couldn't open the link, for some reason.\nJust search 'FlooferLand' on GameJolt and 'Leonz' on YouTube")

func _ready():
	connect("meta_clicked", self, "meta_clicked")
	
	bbcode_text = ("game made by {flooferland} (very cool)\n" \
	+ "amogus drip trap remix made by {leonz} (cool song you hear in-game)") \
	.format(
		{
			"flooferland": Global.bb_link(GameInfo.gamejolt_profile, "FlooferLand"),
			"leonz":       Global.bb_link(GameInfo.leonz_youtube, "Leonz")
		}
	)
