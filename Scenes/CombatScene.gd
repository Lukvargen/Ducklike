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

var gone_through = false
func _on_NextLevelArea_body_entered(body):
	if body is Player:
		if gone_through:
			return
		gone_through = true
		Transition.play_in()
		yield(Transition, "transition_complete")
		$YSort.remove_child(body)
		Global.new_stage()


