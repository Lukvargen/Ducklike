extends Enemy


var target = null

var max_hp = 100

signal dead

enum {
	IDLE,
	BASIC_SHOOT,
	SPLIT_SHOOT,
	SPLIT_SHOOT_EXTRA,
	SPLIT_SHOOT_IN,
	ROTATE_SHOT,
	RANDOM_SHOT,
	
	CIRCLE_SPAWN,
	SPAWN_ENEMIES,
	
}
var state = null

func _ready():
	change_state(IDLE)

var shoot_timer = 0
var shots_counter = 0

var time = 0

func _physics_process(delta):
	shoot_timer -= delta
	time += delta
	
	match state:
		IDLE:
			pass
		BASIC_SHOOT:
			if shoot_timer <= 0:
				shoot((target.global_position - attack_from_pos.global_position).normalized())
				if not anim.is_playing():
					anim.play("shoot")
				shoot_timer = 0.15
			if get_hp_percent() < 0.8:
				change_state(SPLIT_SHOOT)
			
		SPLIT_SHOOT:
			split_shot()
			if get_hp_percent() < 0.7:
				change_state(SPLIT_SHOOT_EXTRA)
		SPLIT_SHOOT_EXTRA:
			split_shot()
			if shots_counter % 6 == 0:
				var dir = (target.global_position - attack_from_pos.global_position).normalized()
				shoot(dir)
				shots_counter += 1
			if get_hp_percent() < 0.5:
				change_state(SPLIT_SHOOT_IN)
		ROTATE_SHOT:
			if shoot_timer <= 0:
				if not anim.is_playing():
					anim.play("shoot")
				var dir = (target.global_position - attack_from_pos.global_position).normalized()
				shoot(dir.rotated(sin(time*3)))
				shoot_timer = 0.1
			if get_hp_percent() < 0.2:
				change_state(RANDOM_SHOT)
		RANDOM_SHOT:
			if shoot_timer <= 0:
				if not anim.is_playing():
					anim.play("shoot")
				var dir = (target.global_position - attack_from_pos.global_position).normalized()
				
				shoot(dir.rotated(rand_range(-2, 2)), 30, 2, 25)
				shoot_timer = 0.05
			

func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	match state:
		IDLE:
			pass
		SPLIT_SHOOT_IN:
			for x in 3:
				for i in 30:
					yield(get_tree().create_timer(0.10, false),"timeout")
					var dir = (target.global_position - attack_from_pos.global_position).normalized()
					shoot(dir.rotated(-deg2rad(30-i)), 160, 3)
					shoot(dir.rotated(deg2rad(30-i)), 160, 3)
					if not anim.is_playing():
						anim.play("shoot")
				yield(get_tree().create_timer(0.5, false),"timeout")
			change_state(ROTATE_SHOT)
		


func split_shot():
	if shoot_timer <= 0:
		var dir = (target.global_position - attack_from_pos.global_position).normalized()
		shoot(dir.rotated(-deg2rad(30)))
		shoot(dir.rotated(deg2rad(30)))
		shots_counter += 1
		if not anim.is_playing():
			anim.play("shoot")
		shoot_timer = 0.15

func _on_AgroArea_body_entered(body):
	if body is Player:
		if target == null:
			change_state(BASIC_SHOOT)
		target = body

func shoot(dir, spd = 120, life_time = 1, acceleration = 10):
	if dead:
		return
	
	var projectile = preload("res://Scenes/MageProjectile.tscn").instance()
	projectile.global_position = attack_from_pos.global_position + dir * 14
	projectile.rotation = dir.angle()
	projectile.velocity = dir * spd
	projectile.life_time = life_time
	projectile.accelleration = acceleration
	get_parent().add_child(projectile)
	pass

func get_hp_percent():
	return hp / float(max_hp)
	pass

var first_dmg = true

onready var hp_progress = $BossHp/Control/ProgressBar
onready var hp_lbl = $BossHp/Control/ProgressBar/Label
func take_dmg(value, stun_time):
	.take_dmg(value, stun_time)
	hp_lbl.text = str(hp)
	hp_progress.value = hp
	if first_dmg:
		$BossHp/AnimationPlayer.play("show")
		first_dmg = false
	if hp <= 0:
		emit_signal("dead")
