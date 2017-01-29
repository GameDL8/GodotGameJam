extends "res://scenes/characters/character.gd"

const STATE_PATROLL = 0
const STATE_ATTACK  = 1
const STATE_RUN_TOWARDS = 2
var DISTANCE_TRAVEL_LIMIT = 9000

const bullet_scn = preload("res://scenes/characters/botctor/botctor_bullet.tscn")

var state = STATE_PATROLL setget set_state,get_state
var player
export (int) var DAMAGE = CONST.DEFAULT_DAMAGE
onready var patroll_timer = get_node("patroll_timer")
onready var shoot_timer = get_node("shoot_timer")
func _init():
	add_to_group("enemy")

func _ready():
	patroll_timer.connect("timeout",self,"update_patroll")

func get_state():
	return state

func update_patroll():
	if dir.length_squared() == 0:
		set_facing(randi() % 4)
		if facing == UP:
			dir = Vector2(0,-1)
		elif facing == DOWN:
			dir = Vector2(0,1)
		elif facing == LEFT:
			dir = Vector2(-1,0)
		elif facing == RIGHT:
			dir = Vector2(1,0)
	else:
		dir = Vector2()

func _fixed_process(delta):
	if state == STATE_ATTACK:
		var distance = player.get_global_pos()-get_global_pos()
		if abs(distance.x) > abs(distance.y):
			if distance.x > 0:
				self.facing = RIGHT
				dir = Vector2(1,0)
			else:
				self.facing = LEFT
				dir = Vector2(-1,0)
		else:
			if distance.y > 0:
				self.facing = DOWN
				dir = Vector2(0,1)
			else:
				self.facing = UP
				dir = Vector2(0,-1)
		if abs(distance.x) < 10 or abs(distance.y) < 10: # Aligned, able to attack
			shoot()

func shoot():
	set_fixed_process(false)
	var b = bullet_scn.instance()
	b.dir = dir
	b.set_pos(get_pos() + dir * 25)
	get_parent().add_child(b)
	dir = Vector2()
	shoot_timer.start()
	yield(shoot_timer,"timeout")
	set_fixed_process(true)

func set_state(new_state):
	if new_state == state:
		return
	
	state = new_state
	if state == STATE_PATROLL:
		patroll_timer.start()
	else:
		patroll_timer.stop()

func _on_hot_area_body_exit( body ):
	if body.is_in_group("player"):
		set_state(STATE_PATROLL)


func _on_attack_trigger_body_enter( body ):
	if body.is_in_group("player"):
		set_state(STATE_ATTACK)
		player = body


func _on_damage_area_body_enter( body ):
	if body.is_in_group("player"):
		body.take_damage(DAMAGE,self)
