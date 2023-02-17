extends Area2D
var Velocity
var speed = 600.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	position += Velocity * speed * delta



func _on_laser_area_entered(area):
	print("laser hit")
	area._on_kill()
	self.queue_free()
	
