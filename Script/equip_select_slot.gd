extends PanelContainer
class_name EquipSelectSlot

enum EquipType {HEAD,ACCESSORY,CHEST,WEAPON,LEGGINGS}
signal ChangeEquip(item_id:int,type:EquipType,index:int)

@onready var option_button: OptionButton = $MarginContainer/OptionButton
@export var slot_type:EquipType = EquipType.ACCESSORY

var connect_player:Player
var accessory_index:int = 0
var current_index:int = -1

func _ready() -> void:
	option_button.get_popup().max_size = Vector2(300,300)
func update(item_id:int):
	set_selected(item_id)
func set_selected(index:int): ##index --> item_id
	var item_id:int = option_button.get_item_id(index)
	current_index = index
	option_button.select(item_id)
	option_button.text = ""
func load_item_array():
	option_button.clear()
	option_button.add_icon_item(null,"卸下",0)
	var item_array:Array[Item] = []
	match slot_type:
		EquipType.WEAPON: item_array = ManagerItem.get_item_type(Item.ItemType.WEAPON)
		EquipType.HEAD: item_array = ManagerItem.get_item_type(Item.ItemType.HEAD)
		EquipType.CHEST: item_array = ManagerItem.get_item_type(Item.ItemType.CHEST)
		EquipType.LEGGINGS: item_array = ManagerItem.get_item_type(Item.ItemType.LEGGINGS)
		EquipType.ACCESSORY: item_array = ManagerItem.get_item_type(Item.ItemType.ACCESSORY)
	for it in item_array:
		option_button.add_icon_item(it.item_texture,it.item_name,it.item_id)
	set_selected(current_index)
func _on_option_button_button_down() -> void:
	load_item_array()
func _on_option_button_item_selected(index: int) -> void:
	var item_id:int = option_button.get_item_id(index)
	set_selected(index)
	ChangeEquip.emit(item_id,slot_type,accessory_index)
