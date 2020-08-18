extends Gun



func attempt_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir.rotated(-0.4), projectile_speed)
		shoot(dir, projectile_speed)
		shoot(dir.rotated(0.4), projectile_speed)
		return true
	return false

func attempt_super_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		
		for i in 5:
			shoot(dir.rotated(-0.4 + i*0.2), projectile_speed)
			#yield(get_tree().create_timer(0.05, false),"timeout")
		
		return true
	return false
