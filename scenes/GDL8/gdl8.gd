
extends CanvasLayer

var anim
var main_menu

func _ready():
	anim = get_node("AnimationPlayer")
	anim.play("default")
	set_process(true)
	pass
	
func _process(delta):
	yield (anim,"finished")
	get_tree().change_scene_to(preload("res://scenes/intro/intro.tscn"))



