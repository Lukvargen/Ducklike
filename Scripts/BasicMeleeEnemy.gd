extends Enemy

var target = null
var speed = 50

var attack_delay = 1
var attack_time = 0

var velocity = Vector2()

var mass = 1.0
var max_force = 3



func _physics_process(delta):
	if target == null:
		return
	var dist = (target.global_position - global_position)
	var dir : Vector2 = dist.normalized()
	
	var desired_velocity = dir * speed
	var steering = desired_velocity - velocity
	
	steering = steering.clamped(max_force)
	steering = steering / mass
	velocity = (velocity + steering).clamped(speed)
	
	velocity = move_and_slide(velocity)
	
	
	
	anim.play("walk")
	
	attack_time -= delta
	if dist.length() < 32:
		attack(dir)
	
	


func attack(dir):
	if attack_time <= 0:
		attack_time = attack_delay
		
		var attack_area = preload("res://Scenes/MeleeAttackArea.tscn").instance()
		attack_area.global_position = attack_from_pos.global_position + dir * 12
		attack_area.rotation = dir.angle()
		attack_area.velocity = dir * 50
		get_parent().add_child(attack_area)
		
		pass
	pass

func _on_AgroArea_body_entered(body):
	if body is Player:
		target = body
		pass
	pass
