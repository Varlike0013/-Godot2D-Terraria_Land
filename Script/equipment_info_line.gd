extends PanelContainer
class_name EquipmentInfoLine

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label_name: Label = $MarginContainer/HBoxContainer/LabelName

func update(item:Item):
	texture_rect.texture = item.item_texture
	label_name.name = item.item_name
