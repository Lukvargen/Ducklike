extends KinematicBody2D
class_name Enemy

export var hp = 3
export var speed = 50
export var dmg = 1

export var hit_vel_mult = 0.1

export var mass = 1.0
export var max_force = 3
export var bonedrop_amount = 2

var velocity = Vector2()

onready var anim = $AnimationPlayer
onready var hit_anim = $HitAnim
onready var hit_sound = $HitAudio
onready var ray = $RayCast2D
onready var attack_from_pos = $AttackFromPos
onready var sprite = $Sprite
onready var stun_timer = $StunTimer




var dead = false




func take_dmg(value, stun_time):
	Global.freeze()
	#Global.camera.trauma = 0.5
	
	hp -= value
	hit_sound.play()
	#hit_anim.play("Hit")
	anim.play("Hit")
	velocity *= hit_vel_mult
	
	var dmg_lbl = preload("res://Scenes/DmgLbl.tscn").instance()
	dmg_lbl.rect_global_position = global_position
	get_tree().current_scene.add_child(dmg_lbl)
	dmg_lbl.init(value)
	
	if hp <= 0:
		call_deferred("die")
	else:
		set_physics_process(false)
		stun_timer.start(stun_time)
		yield(stun_timer,"timeout")
		if not dead:
			set_physics_process(true)


func die():
	if dead:
		return
	dead = true
	var smoke = preload("res://Scenes/SmokeParticle.tscn").instance()
	smoke.global_position = global_position
	get_tree().current_scene.add_child(smoke)
	
	for i in round(rand_range(bonedrop_amount*0.5, bonedrop_amount)):
		var bone = preload("res://Scenes/Bone.tscn").instance()
		bone.global_position = global_position + Vector2(rand_range(-4,4), rand_range(-4, 4))
		get_tree().current_scene.add_child(bone)
	
	
	hide()
#	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.disabled = true
	$HitBox/CollisionShape2D.disabled = true
	set_physics_process(false)
#	get_parent().remove_child(self)
	yield(get_tree().create_timer(1, false),"timeout")
	
	queue_free()

func steer(dir):
	var desired_velocity = dir * speed
	var steering = desired_velocity - velocity
	
	steering = steering.clamped(max_force)
	steering = steering / mass
	velocity = (velocity + steering).clamped(speed)
	return velocity

func move(delta):
	velocity = move_and_slide(velocity)
	if not anim.is_playing():
		anim.play("walk")
	if velocity.x != 0:
		sprite.scale.x = sign(velocity.x)
	pass

func _on_AgroArea_body_entered(body):
	pass

