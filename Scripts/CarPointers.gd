extends Node2D




var time = 0


func _ready():
	if Global.data.used_car or not Global.data.reached_boss:
		queue_free()



func _process(delta):
	var count = 0
	time += delta
	for i in get_children():
		i.scale = Vector2(1,1) + Vector2(1,1)* 0.4 * sin(4*time-deg2rad(count*30))
		count += 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
