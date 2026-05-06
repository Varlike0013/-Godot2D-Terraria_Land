extends PanelContainer
class_name DisplayCharaterNpc

const EQUIP_SELECT_SLOT = preload("uid://djgbro7hx24li")

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var h_box_container_2: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer2
@onready var equip_select_slot_weapon: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot
@onready var equip_select_slot_head: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot2
@onready var equip_select_slot_armor: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot3
@onready var equip_select_slot_htui: EquipSelectSlot = $MarginContainer/HBoxContainer/EquipSelectSlot4

func _ready() -> void:
	pass # Replace with function body.
func load_slots_accessory(accessory_number:int):
	for i in range(accessory_number):
		var slot:EquipSelectSlot = EQUIP_SELECT_SLOT.instantiate()
		h_box_container_2.add_child(slot)
											  
