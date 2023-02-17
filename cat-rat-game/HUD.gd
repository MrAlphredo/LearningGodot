extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_score(score):
	$ScoreLable.text = str(score)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	

func _on_Button_pressed():
	$Button.hide()
	emit_signal("start_game")


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Why just why a second time"
	$MessageLabel.show()
	yield(get_tree().create_timer(1.0),"timeout")
	$Button.show()
	

func _on_MessageTimer_timeout():
	$MessageLabel.hide()


