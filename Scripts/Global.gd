extends Node



var player = null
var camera = null

signal into_complete

signal skulls_changed

var data = {
	intro_played = false,
	skulls = 0,
}



func freeze():
	OS.delay_msec(10)
	pass


func add_skull(amount):
	data.skulls += amount
	emit_signal("skulls_changed", data.skulls)

