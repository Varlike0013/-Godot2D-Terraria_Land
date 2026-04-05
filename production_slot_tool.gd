extends PanelContainer
class_name ProductionSlotTool

signal Pressed(item_tool:Item)

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var label_quality: Label = $MarginContainer/VBoxContainer/LabelQuality
@onready var labe_efc_pickaxe: Label = $MarginContainer/VBoxContainer/LabeEfcPickaxe
@onready var labe_efc_axe: Label = $MarginContainer/VBoxContainer/LabeEfcAxe
@onready var labe_efc_hammer: Label = $MarginContainer/VBoxContainer/LabeEfcHammer

var current_item:Item

func update(item_tool:Item):
	if item_tool.item_type == Item.ItemType.Tool:
		current_item = item_tool
		texture_rect.texture = item_tool.item_texture
		label_quality.text = "x"+str(item_tool.item_quality)
		labe_efc_pickaxe.text = "镐力"+str(item_tool.tool_efficiency_prickaxe)+"%"
		labe_efc_axe.text = "斧力"+str(item_tool.tool_efficiency_axe)+"%"
		labe_efc_hammer.text = "锤力"+str(item_tool.tool_efficiency_hammer)+"%"
func _on_button_button_down() -> void:
	Pressed.emit(current_item)
