extends Node2D


var player = null

var velocity = Vector2()

var time = 1

func _ready():
	velocity = Vector2(1,0).rotated(rand_range(-2*PI, 2*PI)) * 100 * randf()

func _physics_process(delta):
	if player:
		time += delta
		var dir = (player.global_position - global_position).normalized()
		velocity = steer(dir)
		position += velocity * delta
		pass
	else:
		velocity = velocity.linear_interpolate(Vector2(), 0.1)

func steer(dir):
	var desired_velocity = dir * 150
	var steering = desired_velocity - velocity
	
	steering = steering.clamped(2 + time * 3)
#	steering = steering / 0.5
	velocity = (velocity + steering).clamped(150)
	return velocity

func _on_SeekArea_body_entered(body):
	if body is Player:
		player = body
	pass # Replace with function body.


var dead = false
func _on_PickupArea_body_entered(body):
	if body is Player:
		if dead:
			return
		dead = true
		Global.add_skull(1)
		$AudioStreamPlayer.play()
		hide()
		yield(get_tree().create_timer(1, false),"timeout")
		queue_free()
	pass # Replace with function body.
