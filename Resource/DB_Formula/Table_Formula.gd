extends Resource
class_name TableFormula

@export var BUILDING_FORMULA:Array[TableBuildingRow] 

func get_row(id:int)->TableBuildingRow:
	return BUILDING_FORMULA.get(id)
