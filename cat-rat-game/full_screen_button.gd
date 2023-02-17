extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_borderless = false


func _on_Button_pressed():
	OS.window_borderless = not OS.window_borderless
