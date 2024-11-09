extends Spatial

func _ready():
	var sprite = load(
		"res://sprites/other/start cutscene/" + (
			("dababy.png") if Global.dababy_mode else ("amogus.png")
		)
	)
	
	$Sprite.texture = sprite
	$Shadow.texture = sprite
