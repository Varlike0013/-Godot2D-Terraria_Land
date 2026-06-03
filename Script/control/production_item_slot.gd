extends MarginContainer
class_name ProductionItemSlot
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var label: Label = $VBoxContainer/Label

func update(new_info:Vector2): ##id&&quality
	var item:Item = ManagerItem.get_item(int(new_info.x),int(new_info.y))
	texture_rect.texture = item.item_texture
	label.text = "x"+str(item.item_quality)
