extends PanelContainer
class_name ProductionItemMake

signal Pressed(id:int,qua:int,time:float)

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var label_quality: Label = $MarginContainer/VBoxContainer/LabelQuality
@onready var label_time: Label = $MarginContainer/VBoxContainer/LabelTime

var current_id:int
var current_quality:int
var current_time:float

func update(formula:TableFormulaRow):
	current_id = formula.output_items_id.get(0).x
	current_quality = formula.output_items_id.get(0).y
	current_time = formula.time
	texture_rect.texture = ManagerItem.get_item_info(current_id).texture2d
	label_quality.text = "x"+str(current_quality)
	label_time.text = str(current_time)+" sec"
func _on_button_button_down() -> void:
	Pressed.emit(current_id,current_quality,current_time)
