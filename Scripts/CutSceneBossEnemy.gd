extends Enemy
class_name CutsceneBoss


var target = null

var picked_up_bob = false

onready var exit_pos = $"../BossExit".global_position

func _physics_process(delta):
	if picked_up_bob:
		var dir = (exit_pos - global_position).normalized()
		move_and_slide(dir * speed * 2)
		anim.play("walk")
		
		return
	if target == null:
		return
	var dir = (target.global_position - global_position).normalized()
	move_and_slide(dir * speed)
	anim.play("walk")
	pass


func _on_AgroArea_body_entered(body):
	if body is Bob:
		target = body
		pass
	pass


func _on_KidnapRange_body_entered(body):
	if body is Bob:
		$CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree(),"idle_frame")
		body.picked_up()
		body.get_parent().remove_child(body)
		$Position2D.add_child(body)
		body.position = Vector2()
		body.rotate(PI/2.0)
		picked_up_bob = true
	pass # Replace with function body.
