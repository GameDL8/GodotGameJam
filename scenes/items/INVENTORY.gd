extends CanvasLayer

const SLOT_NONE = 0
const SLOT_A    = 1
const SLOT_B    = 2

onready var panel = get_node("panel")
onready var cursor = get_node("panel/cursor")
var idx = 0

var heart_pieces = 0
var off
func _ready():
	panel.hide()
	off = panel.get_node("container").get_pos()
	set_process_input(true)

func add_heart_piece(value):
	if heart_pieces+value >= CONST.HEART_PARTS_NEEDED:
		heart_pieces+=value
		heart_pieces-=CONST.HEART_PARTS_NEEDED
		var player = Globals.get("player")
		player.max_health+=4
		player.health = player.max_health
		HUD.generate_hearts(player)
		DIALOG.show_text("single_text","You completed a heart, now your max health is increased!")
		yield(DIALOG.get_node("dialog"),"finished")
	else:
		heart_pieces+=value
		DIALOG.show_text("single_text",str("You got ",value," piece of heart. Get ",CONST.HEART_PARTS_NEEDED-heart_pieces, " more to increase your max health."))
		yield(DIALOG.get_node("dialog"),"finished")
	return

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_pause(!get_tree().is_paused())
		set_process(get_tree().is_paused())
		if get_tree().is_paused():
			panel.show()
		else:
			panel.hide()
	
	if get_node("panel/container").get_child_count() == 0: return
	
	if panel.is_visible():
		if event.is_action_pressed("ui_left"):
			idx -= 1
		if event.is_action_pressed ("ui_right"):
			idx += 1
		idx = clamp(idx,0,get_node("panel/container").get_child_count() - 1)
		cursor.set_pos(off + get_node("panel/container").get_child(idx).get_pos())
		if event.is_action_pressed("A"):
			get_node("panel/container").get_child(idx).equip(SLOT_A)
		if event.is_action_pressed("B"):
			get_node("panel/container").get_child(idx).equip(SLOT_B)

func add_item(btn_instance):
	get_node("panel/container").add_child(btn_instance)
	print("added item ", btn_instance.get_name())

func get_item_list():
	return get_node("panel/container").get_children()