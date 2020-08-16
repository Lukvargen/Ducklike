extends AudioStreamPlayer



var music = {
	forest = preload("res://Music/Juhani Junkala [Retro Game Music Pack] Level 1.wav")
}

func change_song(to):
	if music[to] == stream:
		return
	playing = false
	stream = music[to]
	playing = true




