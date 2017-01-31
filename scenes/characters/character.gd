extends KinematicBody2D

const RIGHT = 0
const LEFT  = 1
const UP    = 2
const DOWN  = 3
const die_particle_scene = preload("res://scenes/characters/die_particle.tscn")

export(float) var WALK_SPEED = 150
export(int) var max_health = 3

var dir = Vector2()
var is_player = false
var facing = DOWN setget set_facing,get_facing
var can_take_damage = true
var health = max_health setget set_health,get_health

onready var anim = get_node("anim")
onready var sprite = get_node("Sprite")
onready var item_container = get_node("item_container")

func _ready():
	set_fixed_process(true)
	self.health = max_health
	is_player = Globals.get("player") == self

func _fixed_process(delta):
	if !is_player:
		move(dir * WALK_SPEED * delta)

func set_facing(new_dir):
	if new_dir == LEFT:
		item_container.set_rot(deg2rad(90))
	elif new_dir == RIGHT:
		item_container.set_rot(deg2rad(-90))
	elif new_dir == UP:
		item_container.set_rot(deg2rad(0))
	else: # DOWN
		item_container.set_rot(deg2rad(180))
	facing = new_dir

func get_facing():
	return facing

func take_damage(amount, from):
	if not can_take_damage:
		return
	self.health -= amount
	if self == Globals.get("player"):
		HUD.update_health(self)
	can_take_damage = false
	SFX.play("hit")
	sprite.set_modulate(Color(0.8,0,0,1))
	var recoil = (get_global_pos()-from.get_global_pos()).normalized()
	var remaining = 0.2
	while remaining > 0:
		remaining -= get_fixed_process_delta_time()
		move(recoil * get_fixed_process_delta_time() * 270)
		yield(get_tree(),"fixed_frame")
	sprite.set_modulate(Color(1,1,1,1))
	if health <= 0:
		var die = die_particle_scene.instance()
		get_parent().add_child(die)
		die.set_global_pos(get_global_pos())
		set_process(false)
		yield(die.get_node("anim"),"finished")
		if is_in_group("player"):
			get_tree().reload_current_scene()
		else:
			queue_free()
	else:
		can_take_damage = true

func set_health(h):
	h = clamp(h,0,max_health)
	health = h

func get_health():
	return health;