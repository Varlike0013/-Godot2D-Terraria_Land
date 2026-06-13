extends PanelContainer
class_name LTGMaterialGrid

const MATERIAL_SLOT = preload("uid://bktgsiv1vj1q")

@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/GridContainer
@onready var lable_grid_count: Label = $MarginContainer/VBoxContainer/HBoxContainer/Lable_GridCount

@export var grid_size:int = 10

func _ready() -> void:
	clear_slots()
	update_lable_grid_count()
func clear_slots():
	for nd in grid_container.get_children():
		nd.queue_free()
func append_slot(new_id:int):
	if grid_container.get_child_count()>=grid_size:
		return
	var slot:LTGMaterialSlot = get_slot()
	grid_container.add_child(slot)
	slot.update(new_id)
	update_lable_grid_count()
func get_slot()->LTGMaterialSlot:
	var slot:LTGMaterialSlot = MATERIAL_SLOT.instantiate()
	return slot
func update_lable_grid_count():
	lable_grid_count.text = "SlotCount:"+str(grid_container.get_child_count())+"/"+str(grid_size)
