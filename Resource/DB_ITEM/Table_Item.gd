extends Resource
class_name TableItem

const MATERIALS_ID = 0 ##起始id
const WEAPON_ID = 10000 ##起始id
const TOOL_ID = 20000
const ARMOR_ID = 30000 ##起始id

@export_group("TableRows")
@export var MATERIALS:Array[ItemRowMaterials]
@export var WEAPONS:Array[ItemRowWeapon]
@export var TOOLS:Array[ItemRowTool]
@export var ARMOR:Array[ItemRowArmor]

func get_row(id:int)->TableItemRow:
	var result:TableItemRow
	if id<WEAPON_ID:
		result = MATERIALS.get(id)
	elif id<TOOL_ID:
		result = WEAPONS.get(id-WEAPON_ID)
	elif id<ARMOR_ID:
		result = WEAPONS.get(id-TOOL_ID)
	else:
		result = WEAPONS.get(id-ARMOR_ID)
	return result
