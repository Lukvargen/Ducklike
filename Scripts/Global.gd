extends Node



var player = null
var camera = null

signal into_complete

signal skulls_changed

var cheat = true

var lvl = 0

var data = {
	intro_played = false,
	skulls = 0,
	dog_trades = 4,
	won_game = false,
	
	selected_weapon = "gun",
	weapons_unlocked = {
		gun = true,
		shotgun = false,
		laser_gun = false,
	}
}

var enemies = {
	normal = {
		chance = 4,
		scene1 = preload("res://Scenes/Enemies/BasicMeleeEnemy.tscn"),
		scene2 = preload("res://Scenes/Enemies/BasicMeleeEnemy2.tscn")
	},
	fast = {
		chance = 3,
		scene1 = preload("res://Scenes/Enemies/FastMeleeEnemy.tscn"),
		scene2 = preload("res://Scenes/Enemies/FastMeleeEnemy2.tscn")
	},
	slime = {
		chance = 2,
		scene1 = preload("res://Scenes/Enemies/SlimeEnemy.tscn"),
		scene2 = preload("res://Scenes/Enemies/SlimeEnemy2.tscn")
	},
	mage = {
		chance = 1,
		scene1 = preload("res://Scenes/Enemies/MageEnemy.tscn"),
		scene2 = preload("res://Scenes/Enemies/MageEnemy2.tscn")
	}
}

var scenes = [
	preload("res://Scenes/CombatScenes/Forest1.tscn"),
	preload("res://Scenes/CombatScenes/Forest2.tscn"),
	preload("res://Scenes/CombatScenes/Forest3.tscn"),
	preload("res://Scenes/CombatScenes/Forest4.tscn"),
	preload("res://Scenes/CombatScenes/Forest5.tscn"),
	preload("res://Scenes/CombatScenes/Forest6.tscn")
]

var weapons = {
	gun = preload("res://Scenes/Gun.tscn"),
	shotgun = preload("res://Player/Shotgun.tscn"),
	laser_gun = preload("res://Player/LaserGun.tscn"),
}

func _ready():
	randomize()

func freeze():
	OS.delay_msec(10)
	pass


func add_skull(amount):
	data.skulls += amount
	emit_signal("skulls_changed", data.skulls)

func buy(cost):
	if data.skulls >= cost:
		add_skull(-cost)
		return true
	return false

func calculate_max_hp():
	return data.dog_trades

func create_weapon(id):
	var weapon = weapons[id].instance()
	return weapon

func create_random_enemy():
	var total_chance = 0
	for id in enemies:
		total_chance += enemies[id].chance
	var rand_number = int(rand_range(0, total_chance))
	var current_number = 0
	for id in enemies:
		current_number += enemies[id].chance
		if rand_number < current_number:
			if lvl >= 5:
				if randf() < lvl * 0.1:
					return enemies[id].scene2.instance()
				
			return enemies[id].scene1.instance()

func player_dead():
	lvl = 0

func new_stage():
	lvl += 1
	if lvl == 5:
		MusicPlayer.change_song("forest2")
	var rand_stage = scenes[int(rand_range(0, scenes.size()))]
	get_tree().change_scene_to(rand_stage)







