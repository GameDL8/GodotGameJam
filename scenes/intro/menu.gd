extends Patch9Frame

var option = 0
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pointer
var initial_pos
func _ready():
	Globals.set("menu",self)
	pointer = get_node("TextureFrame")
	initial_pos = pointer.get_pos()
	set_process_input(true)

func go_to(o):
	if o ==0:
		DIALOG.fade(0)
		yield(DIALOG.anim,"finished")
		get_tree().change_scene_to(preload("res://scenes/test_level.tscn"))
		print("going to dungeon")
	elif o == 1:
		get_parent().get_node("AnimationPlayer").play("credits")
	elif o == 2:
		get_tree().quit()

func _input(e):
	if not e.is_echo() and e.is_action_pressed("ui_up"):
		if option > 0:
			option-=1
		else:
			option = 2
	elif not e.is_echo() and e.is_action_pressed("ui_down"):
		if option < 2:
			option+=1
		else:
			option = 0
	pointer.set_pos(Vector2(pointer.get_pos().x,initial_pos.y + (22*option)))
	if get_opacity() == 1:
		if not e.is_echo() and e.is_action_pressed("ui_accept"):
			go_to(option)