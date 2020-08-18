extends KinematicBody2D


var velocity = Vector2()

var life_time = 0.0

var hit_enemy = false

func _physics_process(delta):
	life_time += delta
	if life_time > 0.5:
		queue_free()
	
	move_and_slide(velocity)
	
	
	pass


func _on_Area2D_body_entered(body):
	
	if body is TileMap:
		queue_free()
		pass
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	if hit_enemy:
		return
	var body = area.owner
	if body is Enemy:
		hit_enemy = true
		body.take_dmg(1, 0.05)
		queue_free()
		pass
	pass # Replace with function body.
