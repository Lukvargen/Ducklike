extends Area2D


var velocity = Vector2()

var dmg = 1

var enemies_hit = []

func _physics_process(delta):
	
	position += velocity * delta



func _on_MeleeProjectile_area_entered(area):
	var body = area.owner
	if body is Enemy:
		if not enemies_hit.has(body):
			body.take_dmg(dmg, 0.5)
			enemies_hit.append(body)
		#queue_free()
		pass
	pass # Replace with function body.
