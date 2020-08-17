extends Area2D

export var dmg = 1

export var accelleration = 0
export var life_time = 1.0
var current_life_time = 0

var velocity = Vector2()

var consumed = false

func _physics_process(delta):
	current_life_time += delta
	if current_life_time >= life_time:
		consumed = true
		queue_free()
	velocity += velocity.normalized() * accelleration * delta
	position += velocity * delta


func _on_EnemyProjectile_body_entered(body):
	if body is Player:
		if consumed:
			return
		consumed = true
		
		body.take_dmg(dmg)
		
		queue_free()
	elif body is TileMap:
		queue_free()
	pass # Replace with function body.
