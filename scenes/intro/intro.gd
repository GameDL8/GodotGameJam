extends Panel
var text
var logo
var anim
var logo_playing = false
var select_options = false
const DEFAULT_SPEED = 0.5
var play_music = false
var menu
func _init():
	pass
func _ready():
	menu = get_node("menu")
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
		menu.set_pause_mode(PAUSE_MODE_STOP)
		if Input.is_action_pressed("A"):
			anim.seek(anim.get_current_animation_length(), true)
		if anim.get_current_animation_pos() == anim.get_current_animation_length() and not select_options:
			select_options = true
			anim.play("logo")
			logo_playing = true
			
	if logo_playing:
		yield(get_tree(), "idle_frame")
		yield(anim,"finished")
		menu.set_opacity(1)
func end_intro():
	HUD.show()