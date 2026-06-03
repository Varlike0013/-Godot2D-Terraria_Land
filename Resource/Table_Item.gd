extends Resource
class_name TableItem

const MATERIALS_ID = 0 ##起始id
const WEAPON_ID = 10000 ##起始id
const ARMOR_ID = 10000 ##起始id
@export_group("TableRows")
@export var MATERIALS:Array[TableItemRow]
@export var WEAPONS:Array[TableItemRow]

func get_row(id:int)->TableItemRow:
	var result:TableItemRow
	if id<WEAPON_ID:
		result = MATERIALS.get(id-WEAPON_ID)
	elif id<ARMOR_ID:
		result = WEAPONS.get(id-ARMOR_ID)
	return result
