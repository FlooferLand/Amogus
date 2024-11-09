extends AnimationPlayer

func _ready():
	connect("animation_finished", self, "_anim_finished")
	play("Level Start Cutscene")

func _unhandled_key_input(event):
	if event.is_pressed():
		stop()
		_anim_finished(null)

func _anim_finished(_a):
	get_tree().change_scene("res://levels/Scene.tscn")
