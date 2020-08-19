extends Node2D

onready var line = $Line2D
onready var ray = $RayCast2D
onready var area = $SpreadArea
onready var shape = $SpreadArea/CollisionShape2D

var enemies_hit = []

func spawn(dir, super):
	line.add_point(Vector2())
	ray.cast_to = dir * 100
	ray.enabled = true
	ray.force_raycast_update()
	
	if ray.is_colliding():
		#var col = ray.get_co
		line.add_point(ray.get_collision_point() - global_position)
		var col = ray.get_collider().owner
		if col is Enemy:
			enemies_hit.append(col)
			col.take_dmg(1, 0.05)
			
			area.global_position = col.global_position
			
			for i in 3:
				yield(get_tree(),"physics_frame")
				print(area.get_overlapping_areas())
				var enemy = get_closest_enemy()
				if not enemy:
					return
				area.global_position = enemy.global_position
				enemy.take_dmg(1, 0.05)
				enemies_hit.append(enemy)
				
				line.add_point(((enemy.global_position - global_position)/2).rotated(rand_range(-0.25, 0.25)))
				
				line.add_point(enemy.global_position - global_position)
		
	else:
		line.add_point(ray.cast_to)


func get_closest_enemy():
	var target = null
	var closest_dist = 10000000
	var areas = area.get_overlapping_areas()
	for i in areas:
		var enemy = i.owner
		if enemy is Enemy:
			if not enemies_hit.has(enemy):
				var dist = area.global_position.distance_to(enemy.global_position)
				print("dist",dist)
				if dist <= closest_dist:
					target = enemy
					closest_dist = dist
	
	return target
