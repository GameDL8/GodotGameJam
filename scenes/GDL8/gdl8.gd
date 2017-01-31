
extends CanvasLayer

var anim
var main_menu_scn = preload("res://scenes/intro/intro.tscn")
var main_menu

func _ready():
	anim = get_node("AnimationPlayer")
	anim.play("default")
	main_menu = main_menu_scn.instance()
	set_process(true)
	pass
	
func _process(delta):
	yield (anim,"finished")
#	get_tree().call_deferred("add_child",main_menu)
	get_tree().change_scene_to(preload("res://scenes/intro/intro.tscn"))



