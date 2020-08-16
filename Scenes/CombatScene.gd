extends Node2D




func _ready():
	if Global.player:
		Global.player.global_position = $PlayerSpawn.global_position
		$YSort.add_child(Global.player)
	pass
