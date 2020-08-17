extends Enemy

var target = null

var attack_delay = 1
var attack_time = 0




func _physics_process(delta):
	if target == null:
		return
	var dist = (target.global_position - global_position)
	var dir : Vector2 = dist.normalized()
	
	
	velocity = steer(dir)
	
	move(delta)
	
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
		



func _on_AgroArea_body_entered(body):
	if body is Player:
		target = body

