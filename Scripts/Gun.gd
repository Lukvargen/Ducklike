extends Sprite
class_name Gun

onready var spawn_point = $SpawnPoint
onready var audio = $AudioStreamPlayer
onready var anim = $AnimationPlayer

var player_over_pickup = null

export var shoot_delay = 0.25
var shoot_delta = 0

export var projectile_speed = 175
export var rand_spread = 0.05
export (PackedScene) var projectile

signal picked_up

func _process(delta):
	shoot_delta += delta
	
	if Input.is_action_just_pressed("interact"):
		if player_over_pickup:
			player_over_pickup.equip_weapon(self)
			emit_signal("picked_up")
			pass

func attempt_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir, projectile_speed)
		return true
	return false

func attempt_super_attack(dir):
	if shoot_delta >= shoot_delay:
		shoot_delta = 0
		shoot(dir.rotated(rand_range(-0.1, 0.1)), 200)
		yield(get_tree().create_timer(0.1, false),"timeout")
		shoot(dir.rotated(rand_range(-0.1, 0.1)), 200)
		return true
	return false

func shoot(dir, speed):
	audio.play()
	anim.stop()
	dir = dir.rotated(rand_range(-rand_spread, rand_spread))
	anim.play("shoot")
	var p = projectile.instance()
	p.global_position = spawn_point.global_position
	p.rotation = dir.angle()
	p.velocity = dir * speed
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
	if get_parent().owner is KinematicBody2D: # spy dåligt men aja
		return
	
	if body.is_in_group("player"):
		body.call_deferred("equip_weapon",self)
		emit_signal("picked_up")
		#player_over_pickup = body


func _on_Area2D_body_exited(body):
	if get_parent() is KinematicBody2D:
		return
	if body.is_in_group("player"):
		player_over_pickup = null
