extends Area2D


var velocity = Vector2()
var dmg = 0


func init(dmg):
	
	self.dmg = dmg

func _physics_process(delta):
	position += velocity * delta
	pass


func _on_MeleeAttackArea_body_entered(body):
	if body is Player:
		body.take_dmg(dmg)
	pass # Replace with function body.
