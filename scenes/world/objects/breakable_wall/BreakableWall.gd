extends KinematicBody2D
func _init():
	add_to_group("cracked_wall")

func _ready():

	set_fixed_process(true)
	

func _fixed_process(delta):
	move(Vector2())
	
func interact(body):
	var player = Globals.get("player")
		

func destroy():
	print("DESTROYING WALL")
	MUSIC.resume_dungeon_music(true)
	MUSIC.start_play("uat")
	queue_free()