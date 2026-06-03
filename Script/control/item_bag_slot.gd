extends PanelContainer
class_name ItemBagSlot

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label_name: Label = $MarginContainer/HBoxContainer/LabelName
@onready var label_number: Label = $MarginContainer/HBoxContainer/LabelNumber
@onready var check_button: CheckButton = $MarginContainer/HBoxContainer/CheckButton

var connect_item:Item

func update(item:Item):
	connect_item = item
	texture_rect.texture = item.item_texture
	label_name.text = item.item_name
	label_number.text = str(item.item_quality)
func _on_check_button_toggled(toggled_on: bool) -> void:
	connect_item.item_is_show = toggled_on
