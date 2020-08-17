extends Enemy


enum {
	IDLE,
	CHASE,
	ATTACK,
	FLEE
}
var state = null

var target = null

var player_close = false
var in_range = false

func _ready():
	change_state(IDLE)

func _physics_process(delta):
	
	
	match state:
		IDLE:
			if target != null:
				change_state(ATTACK)
			pass
		CHASE:
			if target == null:
				change_state(IDLE)
			else:
				var dir = (target.global_position - global_position).normalized()
				velocity = steer(dir)
				
				move(delta)
			pass
		ATTACK:
			pass
		FLEE:
			var dir = -(target.global_position - global_position).normalized()
			velocity = steer(dir)
			
			move(delta)
			pass
	pass




func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	match state:
		IDLE:
			pass
		CHASE:
			if in_range:
				change_state(ATTACK)
			pass
		ATTACK:
			anim.play("attack")
			yield(anim, "animation_finished")
			yield(get_tree().create_timer(1, false),"timeout")
			if player_close:
				change_state(FLEE)
			else:
				change_state(CHASE)
		FLEE:
			yield(get_tree().create_timer(2, false),"timeout")
			if player_close:
				change_state(ATTACK)
			else:
				change_state(IDLE)
			pass

func _on_AgroArea_body_entered(body):
	if body is Player:
		target = body
		in_range = true
		change_state(ATTACK)

func shoot():
	if dead:
		return
	var dir = (target.global_position - attack_from_pos.global_position).normalized()
	
	var projectile = preload("res://Scenes/MageProjectile.tscn").instance()
	projectile.global_position = attack_from_pos.global_position + dir * 14
	projectile.rotation = dir.angle()
	projectile.velocity = dir * 120
	get_parent().add_child(projectile)
	pass


func _on_AgroArea_body_exited(body):
	if body is Player:
		in_range = false
	pass # Replace with function body.


func _on_PlayerCloseArea_body_entered(body):
	if body is Player:
		player_close = true
	pass # Replace with function body.


func _on_PlayerCloseArea_body_exited(body):
	if body is Player:
		player_close = false
	pass # Replace with function body.
