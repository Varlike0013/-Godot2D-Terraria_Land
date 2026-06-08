extends PanelContainer
class_name BuildingSelectProduction

const PRODUCTION_ITEM_SLOT = preload("uid://boy5m3itr0gk5")
const PRODUCTION_SLOT_FORMULA = preload("uid://cmbmqvc37pddb") 

@onready var vbc_formula: VBoxContainer = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/ScrollContainer/VBCFormula
@onready var item_slot_in: ProductionItemSlot = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBCItemIn/ProductionItemSlot
@onready var label_time: Label = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/TextureRect/LabelTime
@onready var item_slot_out: ProductionItemSlot = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBCItemOut/ProductionItemSlot

var current_building:BuildingProduction

func update(new_bd:BuildingProduction):
	current_building = new_bd
	var bd_row:TableBuildingRow = ManagerBuilding.get_building_info(new_bd.building_id)
	update_formula(bd_row.get_formula_all())
func update_formula(formulas:Array[TableFormulaRow]):
	for fma in formulas:
		append_formula(fma)
func append_formula(formula:TableFormulaRow):
	var row:ProductionSlotFormula = PRODUCTION_SLOT_FORMULA.instantiate()
	vbc_formula.add_child(row)
	row.Pressed.connect(_on_pressed_formula)
	row.update(formula)
func clear_formula():
	for sl in vbc_formula.get_children():
		sl.queue_free()
func _on_pressed_formula(formula:TableFormulaRow):
	if current_building:
		current_building.update_production(formula)
