extends PanelContainer
class_name ProductionItemMake

signal Pressed(id:int,qua:int,time:float)

@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var label_quality: Label = $MarginContainer/VBoxContainer/LabelQuality
@onready var label_time: Label = $MarginContainer/VBoxContainer/LabelTime

var current_id:int
var current_quality:int
var current_time:float

func update(item_id:int,new_qua:int,new_time:float):
	current_id = item_id
	current_quality = new_qua
	current_time = new_time
	texture_rect.texture = ManagerItem.get_item_info(item_id,ManagerItem.ItemInfoType.Texture2d)
	label_quality.text = "x"+str(new_qua)
	label_time.text = str(new_time)+" sec"
func _on_button_button_down() -> void:
	Pressed.emit(current_id,current_quality,current_time)
