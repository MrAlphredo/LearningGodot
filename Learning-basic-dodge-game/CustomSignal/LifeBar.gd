extends TextureProgress
signal health_reach_zero

func _on_Player_health_changed(new_health):
	value = new_health # Replace with function body.
	if new_health<=0:
		_on_health_reach_zero()

func _on_health_reach_zero():
	emit_signal("health_reach_zero") 
