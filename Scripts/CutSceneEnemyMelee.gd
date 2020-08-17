extends Enemy


var target = null

func _physics_process(delta):
	if target == null:
		return
	var dir = (target.global_position - global_position).normalized()
	move_and_slide(dir * speed)
	if not anim.is_playing():
		anim.play("walk")
	pass


func _on_AgroArea_body_entered(body):
	if body is Bob:
		target = body
		pass
	pass
