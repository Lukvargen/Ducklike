extends Node



var player = null
var camera = null

signal into_complete

signal skulls_changed

var cheat = true

var data = {
	intro_played = false,
	skulls = 0,
	dog_trades = 0,
	
	selected_weapon = "laser_gun",
	weapons_unlocked = {
		gun = true,
		shotgun = false,
		laser_gun = false,
	}
}

var enemies = {
	normal = {
		lvl = 3,
		scene = preload("res://Scenes/Enemies/BasicMeleeEnemy.tscn")
	},
	fast = {
		lvl = 3,
		scene = preload("res://Scenes/Enemies/FastMeleeEnemy.tscn")
	},
	slime = {
		lvl = 5
	}
}

var weapons = {
	gun = preload("res://Scenes/Gun.tscn"),
	shotgun = preload("res://Player/Shotgun.tscn"),
	laser_gun = preload("res://Player/LaserGun.tscn"),
}

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
	
