extends MeleeWeapon



func attempt_super_attack(dir):
	if attack_timer >= attack_delay:
		if attack_dir == 1:
			
			anim.play("attack")
		else:
			anim.play_backwards("attack")
		attack_dir *= -1
		
		attack_timer = 0
		spawn_projectile(dir, preload("res://Player/SytheSpecial.tscn"), 0, 2, 0)
		return true
	return false
