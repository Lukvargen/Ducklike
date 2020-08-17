extends Enemy

var target = null

var attack_delay = 1
var attack_time = 0

enum {
	IDLE,
	CHARGE,
	DASH
}
var state = null

func _ready():
	change_state(IDLE)

func _physics_process(delta):
	
	
	match state:
		IDLE:
			pass
		CHARGE:
			
			pass
		DASH:
			move(delta)
	
	

func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	match state:
		IDLE:
			$DmgArea/CollisionShape2D.set_deferred("disabled", true)
			yield(get_tree().create_timer(1, false),"timeout")
			change_state(CHARGE)
		CHARGE:
			hit_anim.play("Charge")
			yield(hit_anim, "animation_finished")
			change_state(DASH)
		DASH:
			$DmgArea/CollisionShape2D.set_deferred("disabled", false)
			var dir : Vector2
			if target == null:
				dir = Vector2(1,0).rotated(rand_range(-2*PI, 2*PI))
			else:
				var dist = (target.global_position - global_position)
				dir = dist.normalized()
			velocity = dir * 600
			pass


func move(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
	
	
	if not anim.is_playing():
		anim.play("walk")
	if velocity.x != 0:
		sprite.scale.x = sign(velocity.x)
	
	velocity = velocity.linear_interpolate(Vector2(), 0.08)
	if velocity.length() < 5:
		change_state(IDLE)



func _on_AgroArea_body_entered(body):
	if body is Player:
		target = body



func _on_DmgArea_body_entered(body):
	if body is Player:
		body.take_dmg(1)
		pass

