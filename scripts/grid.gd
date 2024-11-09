extends Node2D

var target_offset := Vector2.ZERO
var draw_alpha := 2
var _offset := Vector2.ZERO

func _draw():
	var default_fontus = Control.new().get_font("font")
	draw_string(default_fontus, Vector2.ZERO, "Among us", Color(rand_range(0, 1),rand_range(0, 1),rand_range(0, 1)))
	var res = get_viewport_rect().size / 60
	var pos = Global.player.position   / 60
	#var rects_drawn := 0
	for x in range(pos.x - res.x, pos.x + res.x):
		for y in range(pos.y - res.y, pos.y + res.y):
			#rects_drawn += 1
			draw_rect(
				Rect2(
					_offset.x + (x * 64) + 32,
					_offset.y + (y * 64) + 32,
					60,
					60
				),
				Color(1, 1, 1, draw_alpha * 0.01)
			)
	#print(rects_drawn)

