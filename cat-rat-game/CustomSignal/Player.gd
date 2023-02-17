extends Area2D
signal health_changed(new_health)
var health = 5
onready var bullet_laser = preload("../laser.tscn")

var angularSpeed = PI
var speed = 300.0
var isinvinc = false
var dodge_on_CD = false
var previousVel = Vector2(0,0)
var disable_move = false
var previousRotation = 0
var screen_size = Vector2.ZERO
var dodge_range = 300
var start_pos = Vector2(232.0, 300.0)
signal dodge_succeeded

func _ready():
#	var timer = get_node("Timer")
#	timer.connect("timeout",self,"_on_Timer_timeout")
	screen_size = get_viewport_rect().size
	print(screen_size)
	


func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("player_shoot"):
		shoot()
		$AttackTimer.start()
		disable_move = true
		
	
	if not disable_move:
		if Input.is_action_pressed("ui_left"):
			velocity += Vector2.LEFT * speed
		if Input.is_action_pressed("ui_right"):
			velocity += Vector2.RIGHT* speed
		if Input.is_action_pressed("ui_up"):
			velocity += Vector2.UP* speed
		if Input.is_action_pressed("ui_down"):
			velocity += Vector2.DOWN* speed
		
		var curr_angle = velocity.angle()
		if velocity == previousVel:
			pass
		else:
			rotation = curr_angle
			previousRotation = rotation
		if velocity == Vector2.ZERO:
			var mouse_pos = get_viewport().get_mouse_position()
			rotation = (mouse_pos- position).angle()
	elif isinvinc:
		_dodge_move(delta)
	
#	var velocity = Vector2.UP.rotated(rotation) * speed
	if Input.is_action_pressed("player_dodge") and dodge_on_CD == false:
		disable_move = true
		_on_dodge()
		
	
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	
		
		
		

func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
	get_node("AnimationPlayer").play("take_damage")
	emit_signal("health_changed", health)


func _on_area_entered(area):
	if isinvinc:
		area._on_kill()
		emit_signal("dodge_succeeded")
		pass
	else:
		take_damage(2)


func _on_Timer_timeout():
	isinvinc = false
	disable_move = false

func _on_Timer2_timeout():
	dodge_on_CD = false 
	
	
func _on_dodge():
	isinvinc = true
	dodge_on_CD = true
	#var timer = get_node("Timer")
	#timer.connect("timeout",self,"_on_Timer_timeout")
	#timer.start(0.5)
	$Timer.start(0.4)
#	var timer2 = get_node("Timer2")
#	timer2.connect("timeout",self, "on_Timer2_timeout")
#	timer2.start(0.5)
	$Timer2.start(0.5)

func _dodge_move(delta):
	rotation += 5 * PI * delta
	position += Vector2(dodge_range,0).rotated(previousRotation) * delta

func start(new_position):
	position = new_position

func shoot():
	var bullet = bullet_laser.instance()
	get_node("../").add_child(bullet)
	bullet.global_position = $eyePosition.global_position 
	var facing = (get_viewport().get_mouse_position()- position).angle()
	bullet.Velocity = Vector2.RIGHT.rotated(facing)
	bullet.rotation = facing


func _on_AttackTimer_timeout():
	disable_move = false
		
