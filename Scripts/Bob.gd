extends KinematicBody2D
class_name Bob


onready var gun = $Gun
onready var area = $Area2D
onready var anim = $AnimationPlayer

var target = weakref(null)

var seen_enemy = false


func _physics_process(delta):
	if target.get_ref():
		var dist = (target.get_ref().global_position - global_position)
		gun.rotation = dist.angle()
		gun.attempt_attack(dist.normalized())
		if dist.x < 0:
			
			gun.flip_v = true
		elif dist.x > 0:
			gun.flip_v = false
	else:
		for i in area.get_overlapping_bodies():
			if i is Enemy:
				target = weakref(i)
				return



func _on_Area2D_body_entered(body):
	if body is Enemy:
		if not seen_enemy:
			anim.play("!")
			gun.show()
			seen_enemy = true
		target = weakref(body)
		pass
	pass # Replace with function body.


var flipped = false
func _on_BossArea_body_entered(body):
	if body.is_in_group("cutscene_boss"):
		if not flipped:
			anim.play("Flip")
			flipped = true
	pass # Replace with function body.

func picked_up():
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	gun.drop()


func _on_Area2D_body_exited(body):
	if body is Enemy:
		print("?")
		for i in area.get_overlapping_bodies():
			if i is Enemy and target.get_ref() != i:
				target = weakref(i)
				return
		target = weakref(null)
	pass # Replace with function body.
