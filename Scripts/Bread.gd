extends Area2D

onready var tween = $Tween

var throw_speed = 120.0


func init(target_pos):
	if randf() > 0.5:
		$Sprite.flip_h = true
	var dist = global_position.distance_to(target_pos)
	var time = dist / throw_speed
	$AnimationPlayer.playback_speed = 1.0/time
	$AnimationPlayer.play("throw")
	tween.interpolate_property(self, "position", position, target_pos, time,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	
	yield(tween,"tween_all_completed")
	print("aaa")
	var splash = preload("res://Scenes/SpashParticle.tscn").instance()
	splash.global_position = global_position
	get_tree().current_scene.add_child(splash)
	
	pass

func _on_Bread_body_entered(body):
	if body is Player:
		body.eat_bread()
		get_tree().current_scene.bread_eaten()
		var smoke = preload("res://Scenes/SmokeParticle.tscn").instance()
		smoke.global_position = global_position
		get_tree().current_scene.add_child(smoke)
		$AudioStreamPlayer.play()
		$CollisionShape2D.set_deferred("disabled", true)
		hide()
		yield(get_tree().create_timer(1),"timeout")
		queue_free()

