extends CanvasLayer
onready var anim = get_node("AnimationPlayer")
onready var D = get_node("dialog")
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

# This functions just sends the parameters to the real function inside the dialog plugin
func show_text(chapter, dialog, start_at=0):
	HUD.hide()
	D.show_text(chapter,dialog, start_at)
	yield(D,"finished")
	HUD.show()

func fade(a=0):
	if a == 0:
		anim.play("fade_to_black")
	elif a == 1:
		anim.play("fade_black")