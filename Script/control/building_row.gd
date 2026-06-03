extends HBoxContainer
class_name BuildingRow

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var texture_button: TextureButton = $TextureButton

@export var ui_level:LevelUi
var is_has_empty:bool = true

func append_building(bd_id:int):
	var new_bd:BuildingProduction = ManagerBuilding.get_building_id(bd_id)
	h_box_container.add_child(new_bd)
	new_bd.building_row = self
	new_bd.Pressed.connect(_on_building_pressed)
	if size-h_box_container.size<Vector2(300,150):
		texture_button.visible = false
		is_has_empty = false
func _on_texture_button_button_down() -> void:
	ui_level.update_create()
	ui_level.selected_row = self
	ui_level.ui_create.visible = true
func _on_building_pressed(new_bd:BuildingProduction) -> void:
	ui_level.update_select(new_bd)
	ui_level.ui_select.visible = true
