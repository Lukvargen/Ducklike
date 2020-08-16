extends KinematicBody2D


var velocity = Vector2()

var life_time = 0.0

func _physics_process(delta):
	life_time += delta
	if life_time > 1:
		queue_free()
	
	move_and_slide(velocity)
	
	
	pass


func _on_Area2D_body_entered(body):
	if body is Enemy:
		body.take_dmg(1)
		queue_free()
		pass
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	var body = area.owner
	if body is Enemy:
		body.take_dmg(1)
		queue_free()
		pass
	pass # Replace with function body.
