extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Global.data.intro_played:
		hide()
	Global.connect("skulls_changed", self, "skulls_changed")
	Global.connect("into_complete", self, "into_complete")
	
	skulls_changed(Global.data.skulls)


onready var skull_lbl = $SkullContainer/SkullAmountLbl
onready var skull_anim = $SkullContainer/AnimationPlayer
func skulls_changed(skulls):
	skull_lbl.text = str(skulls)
	skull_anim.stop()
	
	skull_anim.play("SkullChanged")

func into_complete():
	$AnimationPlayer.play("show")
