extends Area2D

export var min_speed = 150.0
export var max_speed = 250.0
var Velocity = Vector2(0,0)
onready var facing = 0
onready var previous_facing = 0
signal killed_by_player

func _ready():
	randomize()
	


func _process(delta):
	facing = Velocity.angle()
	if facing != previous_facing:
		_on_rotated()
	position += Velocity*delta
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_rotated():
	if facing >= 0 and facing < PI/2:
		$AnimationPlayer.play("Walk_E") 
		$Sprite.scale.x = 1
	elif facing >= PI/2 and facing <= PI:
		$AnimationPlayer.play("Walk_E") 
		$Sprite.scale.x = -1
	elif facing >= -PI and facing <= -PI/2:
		$AnimationPlayer.play("Walk_N") 
		$Sprite.scale.x = -1	
	elif facing >= -PI/2 and facing <= 0:
		$AnimationPlayer.play("Walk_N") 
		$Sprite.scale.x = 1
	previous_facing = facing

func _on_kill():
	set_process(false)
	$CollisionPolygon2D.queue_free()
	print("on kill rat called BEFORE animation")
	$AnimationPlayer.play("Death")
	print("on kill rat called after animation")
	emit_signal("killed_by_player")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
