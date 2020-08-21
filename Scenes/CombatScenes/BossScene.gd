extends "res://Scenes/CombatScene.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BobArea.hide()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Boss_dead():
	var smoke = preload("res://Scenes/SmokeParticle.tscn").instance()
	smoke.global_position = $BobArea.global_position
	get_tree().current_scene.add_child(smoke)
	$BobArea.show()
	$BobArea/CollisionShape2D.set_deferred("disabled", false)
	pass # Replace with function body.


func _on_BobArea_body_entered(body):
	if body is Player:
		Global.data.won_game = true
		Transition.play_in()
		yield(Transition, "transition_complete")
		get_tree().change_scene_to(load("res://Farm.tscn"))

