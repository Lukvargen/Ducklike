extends KinematicBody2D
class_name Enemy

export var hp = 3

onready var anim = $AnimationPlayer
onready var hit_anim = $HitAnim
onready var hit_sound = $HitAudio
onready var ray = $RayCast2D
onready var attack_from_pos = $AttackFromPos

var dead = false



func take_dmg(value):
	hp -= value
	hit_sound.play()
	hit_anim.play("Hit")
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


#

func _on_AgroArea_body_entered(body):
	pass

