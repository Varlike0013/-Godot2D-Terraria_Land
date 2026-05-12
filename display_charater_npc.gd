extends PanelContainer
class_name DisplayCharaterNpc

const EQUIP_SELECT_SLOT = preload("uid://djgbro7hx24li")

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer2
@onready var equip_select_slot_weapon: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot
@onready var equip_select_slot_head: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot2
@onready var equip_select_slot_armor: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot3
@onready var equip_select_slot_htui: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot4
@onready var test_player: Player = $Player

var connect_player:Player

func _ready() -> void:
	connect_player = test_player
	load_slots_accessory()
	#if connect_player:
		#load_slots_accessory(connect_player.equip_accessory_size)
	#else:
		#load_slots_accessory(1)
func update(player:Player):
	connect_player = player
	if connect_player:
		update_slots(connect_player.equip_accessory_size)
func load_slots_accessory():
	equip_select_slot_weapon.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	equip_select_slot_head.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	equip_select_slot_armor.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	equip_select_slot_htui.ChangeEquip.connect(_on_equip_select_slot_change_equip)
func append_slot():
	var slot:EquipSelectSlot = EQUIP_SELECT_SLOT.instantiate()
	slot.accessory_index = h_box_container_2.get_child_count()
	slot.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	h_box_container_2.add_child(slot)
func remove_slot():
	if h_box_container_2.get_child_count()>0:
		var last_node:Node =  h_box_container_2.get_child(h_box_container_2.get_child_count()-1)
		last_node.queue_free()
func update_slots(accessory_number:int):
	var nodes:Array[EquipSelectSlot] = []
	for nd in h_box_container_2.get_children():
		if nd is EquipSelectSlot:
			nodes.append(nd)
	var size_node:int = nodes.size()
	if accessory_number > size_node:
		for i in range(accessory_number-size_node):
			append_slot()
	elif accessory_number < size_node:
		for i in range(size_node-accessory_number):
			remove_slot()
	var accessory_array:Array[Accessory] = connect_player.equip_accessory
	for i in range(accessory_array.size()): ##todo list check is law
		var slot:EquipSelectSlot = h_box_container_2.get_child(i)
		slot.update(accessory_array.get(i).item_id)
func _on_equip_select_slot_change_equip(item_id: int, type: EquipSelectSlot.EquipType,acs_index:int) -> void:
	if connect_player:
		match type:
			EquipSelectSlot.EquipType.WEAPON: connect_player.set_equip(item_id,Item.ItemType.WEAPON)
			EquipSelectSlot.EquipType.HEAD: connect_player.set_equip(item_id,Item.ItemType.HEAD)
			EquipSelectSlot.EquipType.CHEST: connect_player.set_equip(item_id,Item.ItemType.CHEST)
			EquipSelectSlot.EquipType.LEGGINGS: connect_player.set_equip(item_id,Item.ItemType.LEGGINGS)
			EquipSelectSlot.EquipType.ACCESSORY: connect_player.set_equip(item_id,Item.ItemType.ACCESSORY,acs_index)
