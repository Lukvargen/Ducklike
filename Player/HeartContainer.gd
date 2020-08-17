extends GridContainer


onready var hp_anim = $HeartAnim


func _on_Player_hp_changed(hp, max_hp):
	hp_anim.stop()
	hp_anim.play("HpChanged")
	for heart in get_children():
		if heart is TextureRect:
			heart.update_value(hp)
			hp -= 2
		pass
	pass # Replace with function body.
