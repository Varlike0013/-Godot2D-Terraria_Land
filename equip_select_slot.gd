extends PanelContainer
class_name EquipSelectSlot

enum EquipType {HEAD,ACCESSORY,CHEST,WEAPON,LEGGINGS}
signal ChangeEquip(item_id:int,type:EquipType,index:int)
@onready var option_button: OptionButton = $MarginContainer/OptionButton
@export var slot_type:EquipType = EquipType.ACCESSORY

var connect_player:Player
var accessory_index:int = 0

func _ready() -> void:
	option_button.get_popup().max_size = Vector2(300,300)
func load_item_array():
	option_button.clear()
	option_button.add_icon_item(null,"",0)
	var item_array:Array[Item] = []
	match slot_type:
		EquipType.WEAPON: item_array = ManagerItem.get_item_type(Item.ItemType.WEAPON)
	for it in item_array:
		option_button.add_icon_item(it.item_texture,it.item_name,it.item_id)
	option_button.selected = -1
func _on_option_button_button_down() -> void:
	load_item_array()
func _on_option_button_item_selected(index: int) -> void:
	var item_id:int = option_button.get_item_index(index)
	ChangeEquip.emit(item_id,slot_type,accessory_index)
