extends PanelContainer
class_name DisplayCharaterNpc

const EQUIP_SELECT_SLOT = preload("uid://djgbro7hx24li")

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer2
@onready var equip_select_slot_weapon: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot
@onready var equip_select_slot_head: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot2
@onready var equip_select_slot_armor: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot3
@onready var equip_select_slot_htui: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot4

var connect_player:Player

func _ready() -> void:
	load_slots_accessory(4)
func update(player:Player):
	connect_player = player
func load_slots_accessory(accessory_number:int):
	for i in range(accessory_number):
		var slot:EquipSelectSlot = EQUIP_SELECT_SLOT.instantiate()
		slot.accessory_index = i
		slot.ChangeEquip.connect(_on_equip_select_slot_change_equip)
		h_box_container_2.add_child(slot)
	equip_select_slot_weapon.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	equip_select_slot_head.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	equip_select_slot_armor.ChangeEquip.connect(_on_equip_select_slot_change_equip)
	equip_select_slot_htui.ChangeEquip.connect(_on_equip_select_slot_change_equip)
func _on_equip_select_slot_change_equip(item_id: int, type: EquipSelectSlot.EquipType,acs_index:int) -> void:
	if connect_player:
		match type:
			EquipSelectSlot.EquipType.WEAPON: connect_player.set_equip(item_id,Item.ItemType.WEAPON)
			EquipSelectSlot.EquipType.HEAD: connect_player.set_equip(item_id,Item.ItemType.HEAD)
			EquipSelectSlot.EquipType.CHEST: connect_player.set_equip(item_id,Item.ItemType.CHEST)
			EquipSelectSlot.EquipType.LEGGINGS: connect_player.set_equip(item_id,Item.ItemType.LEGGINGS)
			EquipSelectSlot.EquipType.ACCESSORY: connect_player.set_equip(item_id,Item.ItemType.ACCESSORY,acs_index)
