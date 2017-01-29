extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	MUSIC.start_play("dungeon")
	MUSIC.resume_dungeon_music(true)
	pass
