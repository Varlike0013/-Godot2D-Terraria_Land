extends Node

const BUILDING_SLOT = preload("uid://b6sv0a3tedn65")
const BUILDING_PRODUCTION = preload("uid://uoh64wdou17v")
const DB_FORMULA = preload("uid://blt0k50xuvjuv")

func get_building_id(input_id:int) ->BuildingProduction:
	var info_row:TableBuildingRow = DB_FORMULA.get_row(input_id)
	var packed:PackedScene = BUILDING_PRODUCTION
	if packed:
		var new_bd:BuildingProduction = packed.instantiate()
		new_bd.building_id = input_id
		return new_bd
	return null
func get_building_info(bu_id:int)->TableBuildingRow:
	return DB_FORMULA.get_row(bu_id)
func get_building_formula(bd_id:int)->Array[TableFormulaRow]:
	var info_row:TableBuildingRow = DB_FORMULA.get_row(bd_id)
	var formulas:Array[TableFormulaRow] = info_row.get_formula_all()
	return formulas
func get_building_slot()->BuildingSlot:
	var new_slot:BuildingSlot = BUILDING_SLOT.instantiate()
	return new_slot
