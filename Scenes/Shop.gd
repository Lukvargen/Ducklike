extends Area2D
class_name Shop

var player_over = false
onready var anim = $AnimationPlayer

func _ready():
	$HBoxContainer/Label.text = str(get_cost())
	pass

func _input(event):
	if player_over and event.is_action_pressed("interact"):
		interact()

func interact():
	
	pass

func buy_positive():
	anim.stop()
	anim.play("HaveMoney")
	$HBoxContainer/Label.text = str(get_cost())
	$buyComplete.play()

func buy_negative():
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
	return 0
