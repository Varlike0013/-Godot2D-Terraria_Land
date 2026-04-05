extends PanelContainer
class_name BuildingSlot

signal Pressed(id:int)

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label_name: Label = $MarginContainer/HBoxContainer/LabelName

var building_id:int = -1

func update(int_id:int):
	building_id = int_id
	label_name.text = ManagerBuilding.get_building_info(int_id,ManagerBuilding.BuildingDic.named)
	texture_rect.texture = ManagerBuilding.get_building_info(int_id,ManagerBuilding.BuildingDic.texture2d)
func _on_button_button_down() -> void:
	Pressed.emit(building_id)
