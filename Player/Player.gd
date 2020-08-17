extends KinematicBody2D
class_name Player

signal hp_changed

var velocity = Vector2()


var max_hp = 2
var hp = 2


var in_water = false

var speed = 80
var roll_speed = 150
var water_mult = 1.2

var footstep_counter = 0

onready var anim = $AnimationPlayer
onready var walk_anim = $WalkAnim
onready var sprite = $Sprite

onready var walk1 = $WalkSound1
onready var walk2 = $WalkSound2
onready var hurt_sound = $HurtSound

onready var water_particle = $WaterParticle
onready var ground_particle = $GroundParticles

onready var weapon = $Weapon

onready var camera = $Camera2D

var equiped_weapon = null

var rolling = false

var dead = false

func _ready():
	Global.player = self

func _physics_process(delta):
	var input_dir := Vector2()
	
	input_dir.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_dir.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	input_dir = input_dir.normalized()
	#if input_dir.x != 0 and input_dir.y != 0:
	#	input_dir = Vector2()
	if not rolling:
		velocity = velocity.linear_interpolate(input_dir * speed * (water_mult if in_water else 1), 0.05 if in_water else 0.5)
	
	velocity = move_and_slide(velocity)
	
	if velocity.x != 0:
		sprite.scale = Vector2(sign(velocity.x), 1)
		water_particle.scale = Vector2(sign(velocity.x), 1)
		ground_particle.scale = Vector2(sign(velocity.x), 1)
	
	if velocity.length_squared() > 0.1:
		if in_water:
			ground_particle.emitting = false
			if input_dir != Vector2():
				water_particle.emitting = true
			else:
				water_particle.emitting = false
		else:
			if not rolling:
				walk_anim.play("walk")
				water_particle.emitting = false
				if input_dir != Vector2():
					ground_particle.emitting = true
				else:
					ground_particle.emitting = false
			
			if Input.is_action_just_pressed("roll"):
				rolling = true
				velocity = velocity.normalized() * roll_speed
				if sprite.scale.x == 1:
					walk_anim.play("Roll")
				else:
					walk_anim.play_backwards("Roll")
				yield(walk_anim,"animation_finished")
				rolling = false
	
	if equiped_weapon:
		var dist = (get_global_mouse_position() - global_position)
		#camera.position = dist * 0.1
		equiped_weapon.rotation = dist.angle()
		
		
		if dist.x < 0:
			#equiped_weapon.flip_v = true
			equiped_weapon.scale.y = -1
		elif dist.x > 0:
			#equiped_weapon.flip_v = false
			equiped_weapon.scale.y = 1
		
		if Input.is_action_pressed("attack"):
			equiped_weapon.attempt_shoot(dist.normalized())
	
	#if in_water:
	#	water_particle.emitting = false


func toggle_water(is_water):
	if in_water == is_water:
		return
	in_water = is_water
	if in_water:
		anim.play("enter_water")
		var splash = preload("res://Scenes/SpashParticle.tscn").instance()
		splash.global_position = global_position
		get_tree().current_scene.add_child(splash)
	else:
		anim.play("exit_water")

func play_footstep():
	if footstep_counter % 2 == 0:
		walk1.play()
	else:
		walk2.play()
	footstep_counter += 1

func equip_weapon(weap):
	if weapon.get_child_count() > 0:
		return
	weap.get_parent().remove_child(weap)
	weapon.add_child(weap)
	weap.position = Vector2()
	equiped_weapon = weap

func eat_bread():
	pass



func take_dmg(value):
	anim.play("take_dmg")
	hurt_sound.play()
	var dmg_lbl = preload("res://Scenes/DmgLbl.tscn").instance()
	dmg_lbl.rect_global_position = global_position
	get_tree().current_scene.add_child(dmg_lbl)
	dmg_lbl.init(value)
	
	hp -= value
	emit_signal("hp_changed", hp, max_hp)
	
	if hp <= 0:
		if dead:
			return
		dead = true
		$CollisionShape2D.set_deferred("disabled", true)
		set_physics_process(false)
		hide()
		Transition.play_in()
		yield(Transition, "transition_complete")
		get_tree().change_scene_to(load("res://Farm.tscn"))
	
	pass







