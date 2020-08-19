extends Gun




func attempt_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir, false)
		return true
	return false

func attempt_super_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir, true)
		return true
	return false


func shoot(dir, super):
	audio.play()
	anim.stop()
	anim.play("shoot")
	var p = projectile.instance()
	p.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(p)
	p.spawn(dir, super)

