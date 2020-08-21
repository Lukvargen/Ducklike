extends AudioStreamPlayer



var music = {
	calm = preload("res://Music/Juhani Junkala [Chiptune Adventures] 2. Stage2.wav"),
	under_attacked = preload("res://Music/Juhani Junkala [Chiptune Adventures] 3. Boss Fight.wav"),
	after_attacked = preload("res://Music/Juhani Junkala [Retro Game Music Pack] Title Screen.wav"),
	forest = preload("res://Music/Juhani Junkala [Retro Game Music Pack] Level 1.wav"),
	forest2 = preload("res://Music/Juhani Junkala [Retro Game Music Pack] Level 2.wav"),
	boss = preload("res://Music/Juhani Junkala [Retro Game Music Pack] Level 3.wav"),
}

func change_song(to):
	if music[to] == stream:
		return
	playing = false
	stream = music[to]
	playing = true




