extends KinematicBody2D
class_name Player

signal hp_changed

var velocity = Vector2()


var max_hp = 2
var hp = 2


var in_water = false

var speed = 80
var roll_speed = 150

var roll_powershot_time = 0

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

onready var weapon_anim = $WeaponAnim

var equiped_weapon = null

var rolling = false

var dead = false

func _ready():
	Global.player = self
	
	#var test = preload("res://Player/Dagger.tscn").instance()
#	var test = preload("res://Player/Sword.tscn").instance()
	#var test = preload("res://Player/Scythe.tscn").instance()
	#var test = preload("res://Player/Shotgun.tscn").instance()
#	add_child(test)
	#equip_weapon(test)
	
	var selected_weapon = Global.data.selected_weapon
	if selected_weapon != null:
		equip_weapon(Global.create_weapon(selected_weapon))
	
	print("Global.calculate_max_hp()",Global.calculate_max_hp())
	increase_max_hp(Global.calculate_max_hp())

func _physics_process(delta):
	roll_powershot_time -= delta
	weapon.modulate = Color(1,1,1,1).linear_interpolate(Color(1,1,0,1),clamp(roll_powershot_time,0,1))
	
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
				roll_powershot_time = 1
				rolling = false
	
	if equiped_weapon:
		var dist = (get_global_mouse_position() - global_position)
		#camera.position = dist * 0.1
	#	equiped_weapon.rotation = dist.angle()
		weapon.rotation = dist.angle()
		
		if dist.x < 0:
			#equiped_weapon.flip_v = true
			weapon.scale.y = -1
		elif dist.x > 0:
			#equiped_weapon.flip_v = false
			weapon.scale.y = 1
		
		attack(dist)
	
	#if in_water:
	#	water_particle.emitting = false

func attack(dist):
	if Input.is_action_pressed("attack") and not rolling:
		if roll_powershot_time > 0:
			if equiped_weapon.attempt_super_attack(dist.normalized()):
				roll_powershot_time = 0
		else:
			equiped_weapon.attempt_attack(dist.normalized())

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
	if equiped_weapon:
		equiped_weapon.queue_free()
		equiped_weapon = null
	
	weapon_anim.play("equip")
	if weap.get_parent():
		weap.get_parent().remove_child(weap)
	weapon.add_child(weap)
	weap.position = Vector2()
	equiped_weapon = weap
	
	Global.data.selected_weapon = weap.id

func eat_bread():
	pass



func take_dmg(value):
	anim.play("take_dmg")
	hurt_sound.play()
	var dmg_lbl = preload("res://Scenes/DmgLbl.tscn").instance()
	dmg_lbl.rect_global_position = global_position
	get_tree().current_scene.add_child(dmg_lbl)
	dmg_lbl.init(value)
	Global.camera.trauma = 0.5
	
	hp -= value
	emit_signal("hp_changed", hp, max_hp)
	
	if hp <= 0:
		if dead:
			return
		dead = true
		Global.player_dead()
		$CollisionShape2D.set_deferred("disabled", true)
		set_physics_process(false)
		hide()
		Transition.play_in()
		yield(Transition, "transition_complete")
		get_tree().change_scene_to(load("res://Farm.tscn"))

func increase_max_hp(value):
	max_hp += value
	hp += value
	emit_signal("hp_changed", hp, max_hp)
	pass







