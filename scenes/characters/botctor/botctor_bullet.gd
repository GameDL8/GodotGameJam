extends Area2D

const DAMAGE = 1
var dir = Vector2(0,-1)

func _ready():
	connect("body_enter",self,"_on_player_enter")
	get_node("visibility").connect("exit_screen",self,"queue_free")
	set_fixed_process(true)

func _fixed_process(delta):
	set_pos(get_pos() + dir * delta * CONST.BULLET_SPEED)

func _on_player_enter(body):
	if body.is_in_group("player"):
		body.take_damage(DAMAGE,self)
		queue_free()

