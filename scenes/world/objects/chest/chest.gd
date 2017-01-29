extends StaticBody2D

const HEALTH  = 0
const KEY     = 1
const BOMB    = 2
const SPECIAL = 3
const HEART_PIECE = 4

var empty = false
export (bool) var interactible = false
export (StringArray) var dialogs
export (int,"Health,Key,Bomb,SPECIAL","Heart Piece") var content_type = HEALTH
export (PackedScene) var special_btn # what item will it add to inventory
export (Texture) var texture_health
export (Texture) var texture_key

export (Texture) var texture_show
onready var anim = get_node("anim")
onready var icon = get_node("icon")

func _init():
	add_to_group("interactable")

func interact():
	if empty:
		return false
	if Globals.get("player").facing != 2: # Character is facing UP ?
		return false
	
	if   content_type == HEALTH:
		# TODO: add health
		icon.set_texture(texture_health)
		empty = true
	elif content_type == KEY:
		# TODO: add a key
		icon.set_texture(texture_key)
		empty = true
	elif content_type == BOMB:
		var p = Globals.get("player")
		var boom = Globals.get("bomb")
		if boom == null:
			var item = special_btn.instance()
			print(INVENTORY.get_item_list())
			INVENTORY.add_item(item)
			icon.set_texture(texture_show)
			
			# Play anim and music if the first time the item is got:
			var p = Globals.get("player")
			MUSIC.resume_dungeon_music(true)
			MUSIC.start_play("got item")
			anim.play("open")
			DIALOG.show_text("item","bomb")
			p.set_fixed_process(false)
			get_tree().set_pause(true)
			yield(anim,"finished")
			get_tree().set_pause(false)
			icon.set_texture(null)
			p.set_fixed_process(true)
		else:
			boom.current_stock += 4
			icon.set_texture(texture_show)
#			UPDATE HUD VALUE IF ITEM IS EQUIPPED	
			if p.item_a == boom:
				HUD.update_value(1,boom.current_stock)
			elif p.item_b == boom:
				HUD.update_value(2, boom.current_stock)
			anim.play("open")
		empty = true
	elif content_type == SPECIAL:
		var item = special_btn.instance()
		empty = true
		if empty:
			INVENTORY.add_item(item)
			icon.set_texture(item.icon)
			var p = Globals.get("player")
			MUSIC.resume_dungeon_music(true)
			MUSIC.start_play("got item")
			anim.play("open")
			p.set_fixed_process(false)
			get_tree().set_pause(true)
			yield(anim,"finished")
			get_tree().set_pause(false)
			icon.set_texture(null)
			p.set_fixed_process(true)
	elif content_type == HEART_PIECE:
		empty = true
		icon.set_texture(texture_show)
		var p = Globals.get("player")
		MUSIC.resume_dungeon_music(true)
		MUSIC.start_play("got item")
		anim.play("open")
		INVENTORY.add_heart_piece(2)
		if anim.is_playing():
			p.set_fixed_process(false)
			get_tree().set_pause(true)
			yield(anim,"finished")
			get_tree().set_pause(false)
			p.set_fixed_process(true)
		icon.set_texture(null)
		
	else:
		get_node("lid").set_texture(preload("res://scenes/world/objects/chest/sprite_by_hc/chest_lid.png"))
	return true
