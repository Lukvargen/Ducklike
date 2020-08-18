extends Gun



func attempt_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir.rotated(-0.25), projectile_speed)
		shoot(dir, projectile_speed)
		shoot(dir.rotated(0.25), projectile_speed)
		return true
	return false

func attempt_super_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		
		#for i in 5:
		#	
		
		shoot(dir.rotated(-0.25), projectile_speed)
		shoot(dir, projectile_speed)
		shoot(dir.rotated(0.25), projectile_speed)
		
		shoot(dir.rotated(rand_range(-0.1, 0.1)), 200)
		yield(get_tree().create_timer(0.1, false),"timeout")
		shoot(dir.rotated(rand_range(-0.1, 0.1)), 200)
		return true
	return false
