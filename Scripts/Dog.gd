extends Area2D


var player_over = false
onready var anim = $AnimationPlayer

func _ready():
	$HBoxContainer/Label.text = str(get_cost())
	pass

func _input(event):
	if player_over and event.is_action_pressed("interact"):
		if Global.data.dog_trades > 9:
			return
		if Global.buy(get_cost()):
			anim.stop()
			anim.play("HaveMoney")
			$buyComplete.play()
			Global.data.dog_trades += 1
			Global.player.increase_max_hp(2)
			
			$HBoxContainer/Label.text = str(get_cost())
		else:
			anim.stop()
			anim.play("NoMoney")
			$buyNegative.play()




func _on_Dog_body_entered(body):
	if body is Player:
		player_over = true
		$AnimationPlayer.play("show")
	pass # Replace with function body.


func _on_Dog_body_exited(body):
	if body is Player:
		player_over = false
		$AnimationPlayer.play_backwards("show")
	pass # Replace with function body.

func get_cost():
	return 5 * pow(2, Global.data.dog_trades)
