extends PanelContainer
class_name BuildingSelectProduction

const PRODUCTION_ITEM_SLOT = preload("uid://boy5m3itr0gk5")
const PRODUCTION_SLOT = preload("uid://cmbmqvc37pddb")

@onready var vbc_formula: VBoxContainer = $MarginContainer/HBoxContainer/ScrollContainer/VBCFormula
@onready var vbc_item_in: VBoxContainer = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBCItemIn
@onready var vbc_item_out: VBoxContainer = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBCItemOut
@onready var label_time: Label = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/TextureRect/LabelTime

var current_building:BuildingProduction

func update(array:Array[Dictionary]):
	clear_slot()
	for dic in array:
		var time:float = dic.get(ManagerBuilding.BuildingMake.time)
		var array_in:Array= dic.get(ManagerBuilding.BuildingMake.array_in)
		array_in = array_vector2(array_in)
		var array_out:Array = dic.get(ManagerBuilding.BuildingMake.array_out)
		array_out = array_vector2(array_out)
		append_formula(time,array_in,array_out)
func update_current(time:float,array_in:Array[Vector2],array_out:Array[Vector2]):
	clear_current()
	label_time.text = str(time)+"sec"
	for ar in array_in:
		append_item_slot(ar,true)
	for ar in array_out:
		append_item_slot(ar,false)
	current_building.update_production(time,array_in,array_out)
func append_formula(time:float,array_in:Array[Vector2],array_out:Array[Vector2]):
	var slot:ProductionSlot = PRODUCTION_SLOT.instantiate()
	vbc_formula.add_child(slot)
	slot.Pressed.connect(_on_pressed_formula)
	slot.update(array_in,array_out,time)
func append_item_slot(vec:Vector2,is_input:bool):
	var slot:ProductionItemSlot = PRODUCTION_ITEM_SLOT.instantiate()
	if is_input:
		vbc_item_in.add_child(slot)
	else:
		vbc_item_out.add_child(slot)
	slot.update(vec)
func clear_slot():
	var nodes:Array[Node] = vbc_formula.get_children()
	for nd in nodes:
		nd.queue_free()
func clear_current():
	for sl in vbc_item_in.get_children():
		sl.queue_free()
	for sl in vbc_item_out.get_children():
		sl.queue_free()
func array_vector2(array_in:Array)->Array[Vector2]:
	var new_arr:Array[Vector2] = []
	for ar in array_in:
		if ar is Vector2:
			new_arr.append(ar)
	return new_arr
func _on_pressed_formula(time:float,array_in:Array[Vector2],array_out:Array[Vector2]):
	update_current(time,array_in,array_out)
