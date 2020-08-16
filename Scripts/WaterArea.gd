extends Area2D




func _on_WaterArea_body_entered(body):
	if body is Player:
		body.toggle_water(true)



func _on_WaterArea_body_exited(body):
	if body is Player:
		body.toggle_water(false)

