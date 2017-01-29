extends Node2D

const NEEDED_PULL = 0.5

export (bool) var expendable = false
export (int) var max_stock
export (int) var current_stock

var player
var object
var ray_interact
var pull_acum = 0
var pull_dir

onready var tween = Tween.new()

func _init():
	Globals.set("crane_arm",self)

func _ready():
	add_child(tween)
	tween.set_tween_process_mode(Tween.TWEEN_PROCESS_FIXED)

func use():
	if player == null:
		player = Globals.get("player")
		ray_interact = player.ray_interact
	if !ray_interact.is_colliding():
		return
	if ray_interact.get_collider().is_in_group("can_pickup"):
		player.state = player.STATE_GRAB
		object = ray_interact.get_collider()
		pull_dir = -(ray_interact.get_cast_to().normalized())
		set_fixed_process(true)

func throw():
	if player.facing == player.UP:
		object.pick_anim.play("throw_up")
	elif player.facing == player.DOWN:
		object.pick_anim.play("throw_down")
	elif player.facing == player.LEFT:
		object.pick_anim.play("throw_left")
	elif player.facing == player.RIGHT:
		object.pick_anim.play("throw_right")
	object = null
	pull_acum = 0
	player.state = player.STATE_NORMAL


func _fixed_process(delta):
	if (player.state == player.STATE_GRAB || player.state == player.STATE_PULLING) and not tween.is_active():
		if pull_dir.x != 0:
			if (pull_dir.x > 0 and player.dir.x > 0) or (pull_dir.x < 0 and player.dir.x < 0):
				pull_acum += delta
		elif pull_dir.y != 0:
			if (pull_dir.y > 0 and player.dir.y > 0) or (pull_dir.y < 0 and player.dir.y < 0):
				pull_acum += delta
		else:
			pull_acum = 0
		if pull_acum >= NEEDED_PULL:
			tween.stop_all()
			tween.interpolate_method(object,"set_global_pos",object.get_global_pos(),player.get_global_pos(),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
			object.pick_anim.play("pick")
			tween.start()
			yield(tween,"tween_complete")
			object.set_z(10)
			tween.stop_all()
			player.state = player.STATE_HOLDING
			pull_acum = 0
	elif player.state == player.STATE_HOLDING:
		object.set_global_pos(player.get_global_pos())

func release():
	return
	if player.state == player.STATE_GRAB and not tween.is_active():
		player.state = player.STATE_NORMAL
		object = null
		set_fixed_process(false)