extends Panel
var text
var logo
var anim
const DEFAULT_SPEED = 0.5
var play_music = false
func _init():
	pass
func _ready():
	HUD.hide()
	connect("exit_tree", self, "end_intro")
	text = get_node("RichTextLabel")
	logo = get_node("TextureFrame")
	anim = get_node("AnimationPlayer")
	anim.set_speed(DEFAULT_SPEED) # Too lazy to adjust from the editor
	anim.play("Roll")
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if not play_music:
		play_music = true
		MUSIC.start_play("intro")
	if anim.get_current_animation() == "Roll":
		if Input.is_action_pressed("A"):
			anim.seek(anim.get_current_animation_length(), true)
		if anim.get_current_animation_pos() == anim.get_current_animation_length():
			anim.play("logo")
func end_intro():
	HUD.show()