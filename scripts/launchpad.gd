extends Node2D

# Nodes
onready var launcher     := $Launcher
onready var launch_delay := $LaunchDelay
onready var area         := $Area
onready var anim         := $Animation
onready var audio        := $Audio
onready var sup_beam := {
	"start": $Body/BeamPos0,
	"end":   $Launcher/BeamPos1,
	"obj":   $SupportBeam
}

# Variables
const LAUNCH_SPEED := Vector2(3500, 8000)
var colliding_body: Node2D = null
var can_launch := true  # false while currently launching

# Private functions
func _launcher_entered(body: Node2D):
	colliding_body = body
	if body == Global.player and can_launch:
		can_launch = false
		launch_delay.start()
		audio.play()

func _launcher_exited(body: Node2D):
	colliding_body = null

func _animation_finished(anim: String):
	can_launch = true

func _launch():
	anim.play("Launch")
	if colliding_body == Global.player:
		var vel := Vector2.ZERO
		vel.x -= LAUNCH_SPEED.x * scale.x
		vel.y -= LAUNCH_SPEED.y * scale.y
		Global.player.velocity = vel

# Node functions
func _ready():
	area.connect("body_entered", self, "_launcher_entered")
	area.connect("body_exited",  self, "_launcher_exited")
	anim.connect("animation_finished", self, "_animation_finished")
	launch_delay.connect("timeout", self, "_launch")

func _process(delta):
	update()
	sup_beam.obj.set_point_position(0, to_local(sup_beam.start.global_position))
	sup_beam.obj.set_point_position(1, to_local(sup_beam.end.global_position))
#func _draw():
#	draw_line(
#		to_local(sup_beam.start.global_position),
#		to_local(sup_beam.end.global_position),
#		Color.red,
#		2
#	)
