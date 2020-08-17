extends Node2D


onready var bob = $Bob
var bread_thrown = 0
var bread_needed = 5

var attacked = false

func _ready():
	Transition.play_out()
	if not Global.data.intro_played:
		$Dog.queue_free()
		
		MusicPlayer.change_song("calm")
		yield(get_tree().create_timer(1.0),"timeout")
		spawn_bread()
	else:
		MusicPlayer.change_song("after_attacked")
		$Bob.queue_free()
		$ForestBlock/CollisionShape2D.set_deferred("disabled", true)

func spawn_bread():
	
	var bread = preload("res://Scenes/Bread.tscn").instance()
	add_child(bread)
	bread.global_position = bob.global_position
	var target_pos = $BreadPoints.get_children()[int(rand_range(0, $BreadPoints.get_child_count()))].global_position
	bread.init(target_pos)
	
	
	bread_thrown += 1
	pass

func bread_eaten():
	yield(get_tree().create_timer(rand_range(1, 2)),"timeout")
	
	if not attacked:
		spawn_bread()
		if bread_thrown > bread_needed:
			yield(get_tree().create_timer(rand_range(1, 2)),"timeout")
			start_attack()


func start_attack():
	attacked = true
	MusicPlayer.change_song("under_attacked")
	
	for spawn in $BadEnemiesSpawn.get_children():
		yield(get_tree().create_timer(rand_range(0.5, 2), false),"timeout")
		var smoke = preload("res://Scenes/SmokeParticle.tscn").instance()
		smoke.global_position = spawn.global_position
		get_tree().current_scene.add_child(smoke)
		
		var enemy = preload("res://Scenes/CutSceneEnemyMelee.tscn").instance()
		enemy.global_position = spawn.global_position
		get_tree().current_scene.add_child(enemy)
	
	yield(get_tree().create_timer(2, false),"timeout")
	var smoke = preload("res://Scenes/SmokeParticle.tscn").instance()
	var spawn = $BossSpawn
	smoke.global_position = spawn.global_position
	get_tree().current_scene.add_child(smoke)
	
	var enemy = preload("res://Scenes/CutSceneBossEnemy.tscn").instance()
	enemy.global_position = spawn.global_position
	get_tree().current_scene.add_child(enemy)

func _on_Gun_picked_up():
	$ForestBlock/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.


func _on_ExitFarm_body_entered(body):
	if body is Player:
		Global.data.intro_played = true
		Global.emit_signal("into_complete")
		
		Transition.play_in()
		yield(Transition, "transition_complete")
		MusicPlayer.change_song("forest")
		remove_child(body)
		get_tree().change_scene_to(preload("res://Scenes/CombatScenes/Forest1.tscn"))
		
		
