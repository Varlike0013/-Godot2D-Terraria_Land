extends PanelContainer
class_name TopIndexSlot

@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect

func update(item:Item):
	label.text = "x"+str(item.item_quality)
	texture_rect.texture = item.item_texture
