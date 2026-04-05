extends Node

const BUILDING_SLOT = preload("uid://b6sv0a3tedn65")
const BUILDING_PRODUCTION = preload("uid://uoh64wdou17v")

enum BuildingDic {Null,named,type,texture2d}
enum BuildingMake {Null,time,array_in,array_out}

var Buildings = {
	0:{BuildingDic.named:"伐木场",
		BuildingDic.type:BuildingProduction.BuildingType.Base,
		BuildingDic.texture2d: preload("uid://b2ipcnwydr46h")},
	1:{BuildingDic.named:"矿场",
		BuildingDic.type:BuildingProduction.BuildingType.Base,
		BuildingDic.texture2d: preload("uid://8pb3bporyda5")},
	2:{BuildingDic.named:"熔炼池",
		BuildingDic.type:BuildingProduction.BuildingType.Production,
		BuildingDic.texture2d: preload("uid://dkjahwf8jv4e")},
	3:{BuildingDic.named:"工作区",
		BuildingDic.type:BuildingProduction.BuildingType.Production,
		BuildingDic.texture2d: preload("uid://cters1pwrmqg3")},
	4:{BuildingDic.named:"铸造区",
		BuildingDic.type:BuildingProduction.BuildingType.Production,
		BuildingDic.texture2d: preload("uid://8pb3bporyda5")},
}
var BuildingProductions = {#bd_id:vec3(item_id,quality,time)
	0:[Vector3(0,1,1),Vector3(1,1,1)],
	1:[Vector3(2,1,1)],
}
var BuildingProductionsMake = {#bd_id:time:float,array_in[vec2(item_id,quality)],array_out[vec2(item_id,quality)]
	2:[{BuildingMake.time:3.0,BuildingMake.array_in:[Vector2(2,3)],BuildingMake.array_out:[Vector2(3,1)]}],
	3:[{BuildingMake.time:3.0,BuildingMake.array_in:[Vector2(1,1),Vector2(5,1)],BuildingMake.array_out:[Vector2(6,3)]}],
	4:[{BuildingMake.time:3.0,BuildingMake.array_in:[Vector2(3,10),Vector2(1,3)],BuildingMake.array_out:[Vector2(7,1)]}],
}

func get_building_id(input_id:int) ->BuildingProduction:
	var dir:Dictionary = Buildings.get(input_id)
	var packed:PackedScene =BUILDING_PRODUCTION
	var type:BuildingProduction.BuildingType = dir.get(BuildingDic.type)
	if packed:
		var new_bd:BuildingProduction = packed.instantiate()
		new_bd.building_id = input_id
		new_bd.building_type = type
		return new_bd
	return null
func get_building_dic()->Dictionary:
	return Buildings
func get_building_info(bu_id:int,type:BuildingDic=BuildingDic.Null):
	var info:Dictionary = Buildings.get(bu_id)
	if type == BuildingDic.Null:
		return info
	else:
		return info.get(type)
func get_building_production(bd_id:int)->Array[Vector3]:
	var  array:Array[Vector3] = []
	for ar in BuildingProductions.get(bd_id):
		if ar is Vector3:
			array.append(ar)
	return array
func get_building_make(bd_id:int)->Array[Dictionary]:
	var  array:Array[Dictionary] = []
	for ar in BuildingProductionsMake.get(bd_id):
		if ar is Dictionary:
			array.append(ar)
	return array
func get_building_slot()->BuildingSlot:
	var new_slot:BuildingSlot = BUILDING_SLOT.instantiate()
	return new_slot
