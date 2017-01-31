extends Node2D

func _ready():
	if not Globals.get("saw_intro"):
		DIALOG.show_text("intro","intro")
		yield(DIALOG.get_node("dialog"), "finished")
		Globals.set("saw_intro",true)
	DIALOG.fade(1)
	MUSIC.start_play("dungeon")
	MUSIC.resume_dungeon_music(true)
	INVENTORY.can_pause = true
