extends CanvasLayer


signal transition_complete

func play_in():
	$AnimationPlayer.play("In")

func play_out():
	$AnimationPlayer.play("Out")

func set_black():
	$ColorRect.modulate = Color(0,0,0,1)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_complete")

