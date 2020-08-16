extends Sprite

onready var spawn_point = $SpawnPoint
onready var audio = $AudioStreamPlayer

var player_over_pickup = null

var shoot_delay = 0.25
var shoot_delta = 0

signal picked_up

func _process(delta):
	shoot_delta += delta
	
	if Input.is_action_just_pressed("interact"):
		if player_over_pickup:
			player_over_pickup.equip_weapon(self)
			emit_signal("picked_up")
			pass

func attempt_shoot(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir)

func shoot(dir):
	audio.play()
	var p = preload("res://Scenes/Projectile.tscn").instance()
	p.global_position = spawn_point.global_position
	p.rotation = dir.angle()
	p.velocity = dir * 125
	get_tree().current_scene.add_child(p)

func drop():
	var current_scene = get_tree().current_scene
	var global_pos = global_position
	get_parent().remove_child(self)
	current_scene.add_child(self)
	global_position = global_pos
	pass

func _on_Area2D_body_entered(body):
	if get_parent() is KinematicBody2D:
		return
	if body is Player:
		player_over_pickup = body


func _on_Area2D_body_exited(body):
	if get_parent() is KinematicBody2D:
		return
	if body is Player:
		player_over_pickup = null
