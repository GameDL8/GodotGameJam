extends Panel

var anim
const DEFAULT_SPEED = 1

func _ready():
		
	HUD.hide()
	INVENTORY.can_pause = false
	anim = get_node("AnimationPlayer")
	anim.set_speed(DEFAULT_SPEED) # Too lazy to adjust from the editor
	anim.play("credits")
	yield(anim, "finished")
	get_tree().change_scene_to(preload("res://scenes/GDL8/intro.tscn"))
	pass
