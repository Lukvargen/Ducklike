extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var fps_counter = $FpsCounter

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Global.data.intro_played:
		hide()
	Global.connect("skulls_changed", self, "skulls_changed")
	Global.connect("into_complete", self, "into_complete")
	
	skulls_changed(Global.data.skulls)


var slow = false
func _process(delta):
	if Global.cheat:
		if Input.is_action_just_pressed("show_fps"):
			fps_counter.visible = !fps_counter.visible
		fps_counter.text = "Fps: " + str(Engine.get_frames_per_second())
		
		if Input.is_action_just_pressed("slow"):
			slow = !slow
			if slow:
				Engine.time_scale = 0.2
			else:
				Engine.time_scale = 1.0

onready var skull_lbl = $SkullContainer/SkullAmountLbl
onready var skull_anim = $SkullContainer/AnimationPlayer
func skulls_changed(skulls):
	skull_lbl.text = str(skulls)
	skull_anim.stop()
	
	skull_anim.play("SkullChanged")

func into_complete():
	$AnimationPlayer.play("show")
