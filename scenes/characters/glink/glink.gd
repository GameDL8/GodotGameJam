extends "res://scenes/characters/character.gd"

const STATE_NORMAL  = 0
const STATE_GRAB    = 1
const STATE_HOLDING = 2
const STATE_PUSHING = 3
const STATE_PULLING = 4

export(Array) var facing_textures

var item_a
var item_b
var state = STATE_NORMAL setget set_state,get_state

onready var ray_interact = get_node("ray_interact")
onready var anim_tree = get_node("anim_tree")

func _init():
	add_to_group("player")
	Globals.set("player", self)

func _ready():
	set_process_input(true)
	ray_interact.add_exception(self)
	HUD.generate_hearts(self)
	anim_tree.set_active(true)

func _input(event):
	if anim.get_current_animation() == "attack":
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0: set_facing(RIGHT)
		else: set_facing(LEFT)
	elif abs(dir.x) < abs(dir.y):
		if dir.y > 0: set_facing(DOWN)
		else: set_facing(UP)
	dir.normalized()

	if state == STATE_NORMAL:
		if event.is_action_pressed("A"):
			if not interact():
				if item_a != null:
					if item_a.expendable:
						if item_a.current_stock == 0:
							return
						else:
							item_a.current_stock -=1
							HUD.update_value(INVENTORY.SLOT_A, item_a.current_stock) # Update the value on the hud
							item_a.use()
					else:
						item_a.use()
				if item_a == null:
					if ray_interact.get_collider() != null and ray_interact.get_collider().is_in_group("cracked_wall"):
						DIALOG.show_text("objects","wall")
				

		if item_a != null && event.is_action_released("A"):
			item_a.release()
		if item_b != null && event.is_action_pressed("B"):
			if item_b.expendable:
				if item_b.current_stock == 0:
					return
				else:
					item_b.current_stock -=1
					HUD.update_value(INVENTORY.SLOT_B,item_b.current_stock)
					item_b.use()
			else:
				item_b.use()
		if item_b != null && event.is_action_released("B"):
			item_b.release()
	elif state == STATE_HOLDING:
		if event.is_action_pressed("A") or event.is_action_pressed("B"):
			Globals.get("crane_arm").throw()

func _fixed_process(delta):
	# Override character's method to allow push objects
	var mov = Vector2()
	anim_tree.timescale_node_set_scale("speed",dir.length_squared())
	if health <= 0:
		item_a = null
		item_b = null
		HUD.reset_buttons()
		if INVENTORY.get_node("panel/container").get_child_count() > 0:
			for child in INVENTORY.get_node("panel/container").get_children():
				child.queue_free()
	if state != STATE_GRAB:
		mov = move(dir * WALK_SPEED * delta)
		if mov.length_squared() > 0 and state != STATE_HOLDING:
			self.state = STATE_PUSHING
		elif state != STATE_HOLDING:
			self.state = STATE_NORMAL
	if state == STATE_NORMAL || state == STATE_PUSHING:
		if ray_interact.is_colliding():
			if ray_interact.get_collider() != null and ray_interact.get_collider() .is_in_group("pushable"):
				var dir_facing = ray_interact.get_cast_to()
				if mov.x != 0 and dir_facing.x != 0:
					ray_interact.get_collider().push(delta,1,dir_facing.normalized())
				elif mov.y != 0 and dir_facing.y != 0:
					ray_interact.get_collider().push(delta,1,dir_facing.normalized())
	
func set_facing(new_dir):
	sprite.set_texture(facing_textures[new_dir])
	if new_dir == UP:
		ray_interact.set_cast_to(Vector2(0,-20))
	elif new_dir == DOWN:
		ray_interact.set_cast_to(Vector2(0,20))
	elif new_dir == LEFT:
		ray_interact.set_cast_to(Vector2(-20,0))
	elif new_dir == RIGHT:
		ray_interact.set_cast_to(Vector2(20,0))
	.set_facing(new_dir) # Call character.gd 's set_facing function

func interact():
	if not ray_interact.is_colliding():
		return false
	if ray_interact.get_collider().is_in_group("interactable"):
		return ray_interact.get_collider().interact()
	else:
		return false

func set_state(s):
	state = s
	if s == STATE_NORMAL:
		anim_tree.blend2_node_set_amount("state_1", 0)
		anim_tree.blend2_node_set_amount("state_2", 0)
		anim_tree.blend2_node_set_amount("state_3", 0)
	elif s == STATE_GRAB || s == STATE_PUSHING:
		anim_tree.blend2_node_set_amount("state_1", 0)
		anim_tree.blend2_node_set_amount("state_2", 1)
		anim_tree.blend2_node_set_amount("state_3", 0)
	elif s == STATE_HOLDING:
		anim_tree.blend2_node_set_amount("state_1", 1)
		anim_tree.blend2_node_set_amount("state_2", 0)
		anim_tree.blend2_node_set_amount("state_3", 0)

func get_state():
	return state