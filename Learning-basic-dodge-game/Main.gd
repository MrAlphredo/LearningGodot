extends Node2D

export (PackedScene) var mob_scene
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() 

signal game_over

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func new_game():
	score = 0
	$HUD.update_score(score)
	$Player1.position = $Player1.start_pos
	$Player1.show()
	$Player1.health = 5
	$LifeBar.max_value = $Player1.health
	$LifeBar.value = $Player1.health
	$LifeBar.show()
	$StartTimer.start()
	$HUD/MessageLabel.text = "Get Ready!"
	
	yield($StartTimer, "timeout")
	$ScoreTimer.start()
	$MobSpawnTimer.start()
	$HUD/MessageLabel.hide()
	
	
func game_over():
	emit_signal("game_over")
	get_tree().call_group("mobs","_on_kill")
	$ScoreTimer.stop()
	$MobSpawnTimer.stop()
	$HUD.show_game_over()
	$Player1.hide()
	$LifeBar.hide()


func _on_MobSpawnTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	var mob = mob_scene.instance()
	add_child(mob)
	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI/4)
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed),0)
	mob.Velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)




func _on_LifeBar_health_reach_zero():
	game_over()
