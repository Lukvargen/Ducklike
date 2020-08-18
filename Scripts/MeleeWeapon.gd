extends Sprite
class_name MeleeWeapon

onready var anim = $AnimationPlayer
onready var audio = $AudioStreamPlayer
onready var spawn_point = $SpawnPoint

export (PackedScene) var projectile
export var projectile_speed = 0
export var attack_delay = 0.5
export var projectile_offset = 14

var attack_timer = 0.0



var attack_dir = 1

func _physics_process(delta):
	attack_timer += delta
	pass

func attempt_attack(dir):
	if attack_timer >= attack_delay:
		 
		if attack_dir == 1:
			
			anim.play("attack")
		else:
			anim.play_backwards("attack")
		attack_dir *= -1
		
		attack_timer = 0
		spawn_projectile(dir, projectile, projectile_speed)

func attempt_super_attack(dir):
	return true

func spawn_projectile(dir, proj, spd, dmg = 1, p_offset = projectile_offset):
	audio.play()
	var p = proj.instance()
	p.global_position = global_position + dir * p_offset #spawn_point.position
	p.rotation = dir.angle()
	p.velocity = dir * spd
	p.dmg = dmg
	get_tree().current_scene.add_child(p)

