extends MeleeWeapon


func attempt_super_attack(dir):
	if attack_timer >= attack_delay:
		print("?")
		if attack_dir == 1:
			
			anim.play("attack")
		else:
			anim.play_backwards("attack")
		attack_dir *= -1
		
		attack_timer = 0
		spawn_projectile(dir, preload("res://Player/MeleeFireballProjectile.tscn"), projectile_speed*2, 2)
		return true
	return false

