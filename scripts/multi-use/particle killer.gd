extends Particles2D

# Nodes
onready var timer = $Timer

# Node functions
func _ready():
	timer.connect("timeout", self, "queue_free")
	emitting = true
	timer.start(0)
