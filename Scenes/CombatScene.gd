extends Node2D


export(PackedScene) var next_scene

onready var ysort = $YSort

func _enter_tree():
	Transition.set_black()


func _ready():
	if Global.player:
		Transition.play_out()
		#yield(Transition, "transition_complete")
		
		for i in $EnemySpawnpoints.get_children():
			if randf() > 0.1:
				var enemy = Global.create_random_enemy()
				enemy.global_position = i.global_position
				ysort.add_child(enemy)
				
				pass
		
		
		Global.player.global_position = $PlayerSpawn.global_position
		ysort.add_child(Global.player)
	pass


func _on_NextLevelArea_body_entered(body):
	if body is Player:
		#if next_scene == null:
		#	print("Next Scene is null!")
		#	return
		Transition.play_in()
		yield(Transition, "transition_complete")
		$YSort.remove_child(body)
		#get_tree().change_scene_to(next_scene)
		Global.new_stage()
		pass
	pass # Replace with function body.

