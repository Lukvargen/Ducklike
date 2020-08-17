extends Control


func init(value):
	var tween = $Tween
	$Label.text = str(value)
	rect_position.x += rand_range(-4, 4)
	tween.interpolate_property(self, "rect_position", rect_position, rect_position + Vector2(0, -16), 1,Tween.TRANS_SINE,Tween.EASE_IN)
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.5,Tween.TRANS_CUBIC,Tween.EASE_IN,0.5)
	tween.start()
	yield(tween,"tween_all_completed")
	queue_free()
