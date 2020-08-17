extends TextureRect



var full = preload("res://Textures/HeartFull.png")
var half = preload("res://Textures/HeartHalf.png")
var empty = preload("res://Textures/HeartEmpty.png")


func update_value(value):
	value = clamp(value, 0, 2)
	match value:
		0:
			texture = empty
		1:
			texture = half
		2:
			texture = full

