extends PanelContainer
class_name BuildingSelectProduction

const PRODUCTION_ITEM_SLOT = preload("uid://boy5m3itr0gk5")
const PRODUCTION_SLOT_FORMULA = preload("uid://cmbmqvc37pddb") 

@onready var vbc_formula: VBoxContainer = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBCFormula
@onready var gdc_input: GridContainer = $MarginContainer/HBoxContainer/MarginContainer/CenterContainer/HBoxContainer/GDC_INPUT
@onready var gdc_output: GridContainer = $MarginContainer/HBoxContainer/MarginContainer/CenterContainer/HBoxContainer/GDC_OUTPUT
@onready var label_time: Label = $MarginContainer/HBoxContainer/MarginContainer/CenterContainer/HBoxContainer/TextureRect/LabelTime

var current_building:BuildingProduction

func update(new_bd:BuildingProduction):
	current_building = new_bd
	var bd_row:TableBuildingRow = ManagerBuilding.get_building_info(new_bd.building_id)
	update_formula(bd_row.get_formula_all())
func update_current(formula:TableFormulaRow):
	update_gdc(formula.input_items_id,gdc_input,true)
	label_time.text = str(formula.time)+" Sec"
	update_gdc(formula.output_items_id,gdc_output,false)
func update_gdc(array:Array[Vector2],gdc:GridContainer,is_input:bool):
	var count:int = 0
	for ar in array:
		var slot:ProductionItemSlot = gdc.get_child(count)
		if slot:
			slot.update(ar)
		else:
			append_slot(ar,is_input)
		count += 1
	for i in range(gdc.get_child_count() - 1, count - 1, -1):
		gdc.get_child(i).queue_free()
func update_formula(formulas:Array[TableFormulaRow]):
	var count:int = 0
	for fma in formulas:
		var slot:ProductionSlotFormula = vbc_formula.get_child(count)
		if slot:
			slot.update(fma)
		else:
			append_formula(fma)
		count += 1
	for i in range(vbc_formula.get_child_count() - 1, count - 1, -1):
		vbc_formula.get_child(i).queue_free()
func append_formula(formula:TableFormulaRow):
	var row:ProductionSlotFormula = PRODUCTION_SLOT_FORMULA.instantiate()
	vbc_formula.add_child(row)
	row.Pressed.connect(_on_pressed_formula)
	row.update(formula)
func append_slot(info:Vector2,is_input:bool = true):
	var slot:ProductionItemSlot = PRODUCTION_ITEM_SLOT.instantiate()
	if is_input:
		gdc_input.add_child(slot)
	else:
		gdc_output.add_child(slot)
	slot.update(info)
func clear_formula():
	for sl in vbc_formula.get_children():
		sl.queue_free()
func clear_slots():
	for sl in gdc_input.get_children():
		sl.queue_free()
	for sl in gdc_output.get_children():
		sl.queue_free()
func _on_pressed_formula(formula:TableFormulaRow):
	if current_building:
		current_building.update_production(formula)
