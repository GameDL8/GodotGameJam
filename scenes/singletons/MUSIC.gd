extends StreamPlayer

var music = {
"dungeon": preload("res://audio/music/Dungeon Excerpt.ogg"),
"got item": preload("res://audio/music/Got item.ogg"),
"intro": preload("res://audio/music/intro.ogg"),
"uat": preload("res://audio/music/uat.ogg")
}

var resume_dungeon_music = false

func resume_dungeon_music(ok):
	if typeof(ok) != TYPE_BOOL:
		return
	resume_dungeon_music = ok
	

func _ready():
	connect("finished",self,"finished_song")
	pass


func start_play(song):
	if music.has(song):
		print("PLAY SONG")
		set_stream(music[song])
		print(typeof(music[song]))
		play()

func finished_song():
	if resume_dungeon_music:
		start_play("dungeon")