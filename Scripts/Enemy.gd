extends KinematicBody2D
class_name Enemy

export var hp = 3
export var speed = 50

export var mass = 1.0
export var max_force = 3

var velocity = Vector2()

onready var anim = $AnimationPlayer
onready var hit_anim = $HitAnim
onready var hit_sound = $HitAudio
onready var ray = $RayCast2D
onready var attack_from_pos = $AttackFromPos
onready var sprite = $Sprite

var dead = false



func take_dmg(value):
	hp -= value
	hit_sound.play()
	hit_anim.play("Hit")
	velocity *= 0.1
	if hp <= 0:
		call_deferred("die")


func die():
	if dead:
		return
	dead = true
	var smoke = preload("res://Scenes/SmokeParticle.tscn").instance()
	smoke.global_position = global_position
	get_tree().current_scene.add_child(smoke)
	
	hide()
#	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.disabled = true
	$HitBox/CollisionShape2D.disabled = true
	set_physics_process(false)
#	get_parent().remove_child(self)
	yield(get_tree().create_timer(1),"timeout")
	
	queue_free()

func steer(dir):
	var desired_velocity = dir * speed
	var steering = desired_velocity - velocity
	
	steering = steering.clamped(max_force)
	steering = steering / mass
	velocity = (velocity + steering).clamped(speed)
	return velocity

func move():
	velocity = move_and_slide(velocity)
	anim.play("walk")
	if velocity.x != 0:
		sprite.scale.x = sign(velocity.x)
	pass

func _on_AgroArea_body_entered(body):
	pass

