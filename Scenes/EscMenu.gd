extends CanvasLayer

onready var col = $ColorRect

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("esc"):
			toggle_pause()
			

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(0.5) * 20)

func _on_Continue_pressed():
	toggle_pause()
	pass # Replace with function body.


func toggle_pause():
	col.visible = !col.visible
	if col.visible:
		$PauseIn.play()
		#Engine.time_scale = 0
		get_tree().paused = true
	else:
		$PauseOut.play()
		get_tree().paused = false
	pass


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(value) * 20)
	pass # Replace with function body.


func _on_EffectsSlider_value_changed(value):
	pass # Replace with function body.