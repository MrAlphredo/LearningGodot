extends Node2D

export (PackedScene) var mob_scene
export (PackedScene) var player_scene
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

signal game_over

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func new_game():
	score = 0
	$HUD.update_score(score)
	var player1 = player_scene.instance()
	add_child(player1)
	player1.connect("health_changed", $LifeBar,"_on_Player_health_changed")
	player1.position = player1.start_pos
	player1.show()
	player1.health = 5
	$LifeBar.max_value = player1.health
	$LifeBar.value = player1.health
	$LifeBar.show()
	$StartTimer.start()
	$HUD/MessageLabel.text = "Get Ready!"
	
	yield($StartTimer, "timeout")
	#$ScoreTimer.start()
	$MobSpawnTimer.start()
	$HUD/MessageLabel.hide()
	
	
func game_over():
	emit_signal("game_over")
	get_tree().call_group("mobs","queue_free")
	#$ScoreTimer.stop()
	$MobSpawnTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("Players","queue_free")
	$LifeBar.hide()


func _on_MobSpawnTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	var mob = mob_scene.instance()
	add_child(mob)
	mob.connect("killed_by_player", self, "_on_rat_killed_by_player")
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


func _on_Player1_dodge_succeeded():
	score += 1
	$HUD.update_score(score)


func _on_rat_killed_by_player():
	score += 1
	$HUD.update_score(score)
	
