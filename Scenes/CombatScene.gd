extends Node2D


export(PackedScene) var next_scene

func _enter_tree():
	Transition.set_black()


func _ready():
	if Global.player:
		Transition.play_out()
		#yield(Transition, "transition_complete")
		Global.player.global_position = $PlayerSpawn.global_position
		$YSort.add_child(Global.player)
	pass


func _on_NextLevelArea_body_entered(body):
	if body is Player:
		if next_scene == null:
			print("Next Scene is null!")
			return
		Transition.play_in()
		yield(Transition, "transition_complete")
		$YSort.remove_child(body)
		get_tree().change_scene_to(next_scene)
		pass
	pass # Replace with function body.
