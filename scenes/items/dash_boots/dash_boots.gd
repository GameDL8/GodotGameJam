extends Node2D

var player
var walk_speed
export (bool) var expendable = false
export (int) var max_stock
export (int) var current_stock

onready var particles = get_node("particles")

func _init():
	Globals.set("dash_boots",self)
	DIALOG.show_text("item","boots")

func use():
	if player == null:
		player = Globals.get("player")
		walk_speed = player.WALK_SPEED
	player.WALK_SPEED = walk_speed * 1.3
	particles.set_emitting(true)
	
func release():
	player.WALK_SPEED = walk_speed
	particles.set_emitting(false)