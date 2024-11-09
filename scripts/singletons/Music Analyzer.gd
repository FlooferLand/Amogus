#extends Node
#
## Music sync stufaf
#const bpm := 94
#const measures := 4
#const sec_per_beat := 60.0 / bpm
#onready var song: AudioStreamPlayer
#var song_position := 0
#var song_position_in_beats := 0
#var song_position_in_measures := 0
#var last_reported_beat := 0
#var started := false
#
## Signals
#signal beat(beats)
#signal measure(measures)
#
#func _report_beat():
#	if last_reported_beat < song_position_in_beats:
#		if song_position_in_measures > measures:
#			song_position_in_measures = 1
#		emit_signal("beat", song_position_in_beats)
#		emit_signal("measure", song_position_in_measures)
#		last_reported_beat = song_position_in_beats
#		song_position_in_measures += 1
#
#func _physics_process(delta):
#	if not started or not is_instance_valid(song) or Global.audio_sync_intensity < 0.1:
#		return
#	song_position = song.get_playback_position() + AudioServer.get_time_since_last_mix()
#	song_position -= AudioServer.get_output_latency()
#	song_position_in_beats = int(floor(song_position / sec_per_beat))
#	_report_beat()
#
#
#####################
## Public functions #
#####################
#
#func start():
#	song = Global.player.get_tree().get_nodes_in_group("music")[0]
#	started = true
