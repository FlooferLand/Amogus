extends Label

onready var timer = $Millisecond
onready var time: float = 0.0
var stopped = true

func _pass_time():
	time += 0.01
func _ready():
	timer.connect("timeout", self, "_pass_time")

func _physics_process(delta):
	text = "Time: " + str(time)

# Public
func start():
	time = 0.0
	timer.start(0)
	stopped = false
func stop():
	timer.stop()
	stopped = true
func reset():
	time = 0.0
	timer.stop()
	stopped = true
