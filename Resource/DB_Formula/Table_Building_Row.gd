extends Resource
class_name TableBuildingRow

@export var Building_name:String
@export var building_texture:Texture2D
@export var Building_formula:Array[TableFormulaRow]

func get_row(id:int)->TableFormulaRow:
	return Building_formula.get(id)
func get_formula_all()->Array[TableFormulaRow]:
	return Building_formula
