extends PanelContainer
class_name EquipSelectSlot

enum EquipType {HEAD,ACCESSORY,ARMOR,WEAPON,HTUI}

@onready var option_button: OptionButton = $OptionButton

@export var slot_type:EquipType = EquipType.ACCESSORY

func _ready() -> void:
	load_item_array()
func load_item_array():
	option_button.clear()
	option_button.add_icon_item(null,"卸下")
	if slot_type == EquipType.WEAPON:
		ManagerItem.get_item_type(Item.ItemType.WEAPON)
