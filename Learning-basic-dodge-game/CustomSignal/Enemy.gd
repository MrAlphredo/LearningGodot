extends Area2D

export var min_speed = 150.0
export var max_speed = 250.0

var angle_increase_speed = PI
var radius = Vector2(300.0, 150.0)
var angle = 0.0
var Velocity = Vector2.ZERO
const bobbing_freq = 0.1
const bobbing_amp = 0.2

onready var start_position = position
onready var previous_position = start_position
onready var bobbing_offset = 0

func _ready():
	randomize()
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi()%mob_types.size()]

func _process(delta):
	position += fluctuate_position() + Velocity*delta
	
	
func fluctuate_position():
	bobbing_offset = wrapf(bobbing_offset + bobbing_freq , 0.0, 2*PI)
	return Vector2(0,bobbing_amp * sin(bobbing_offset))


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_kill():
	queue_free()
