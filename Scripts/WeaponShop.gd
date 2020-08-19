extends Shop

export var bone_cost = 0

export var weapon_id = ""

func _ready():
	if Global.data.weapons_unlocked[weapon_id]:
		$AnimationPlayer.play("Bought")

func interact():
	if Global.data.weapons_unlocked[weapon_id]:
		# just equip
		buy_positive()
		Global.player.equip_weapon(Global.create_weapon(weapon_id))
		return
	if Global.buy(get_cost()):
		Global.data.weapons_unlocked[weapon_id] = true
		# equip
		Global.player.equip_weapon(Global.create_weapon(weapon_id))
		buy_positive()
		$AnimationPlayer.play("Bought")
	else:
		buy_negative()
	
	pass


func get_cost():
	return bone_cost
