extends StaticBody2D
var area

func _ready():
	area = get_node("Area2D")
	area.connect("body_enter", self, "interact")

func interact(body):
	if body != Globals.get("player"):
		return
	DIALOG.show_text("alpaca","end")
	yield(DIALOG.D, "dialog_control")
	DIALOG.fade(0)
	DIALOG.fade(1)
	yield(DIALOG.D, "finished")
	get_tree().change_scene_to(preload("res://scenes/credits/credits.tscn"))
