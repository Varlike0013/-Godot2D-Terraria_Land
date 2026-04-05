extends Node

enum ItemInfoType{Name,Texture2d,Type,Null,ToolEfc,ToolDurability,ToolType}
const ITEM_BAG = preload("uid://bgosrqbnyvula")
const ItemNoRemoveList = [5000]
const ItemInfo:Dictionary = {
	0:{ItemInfoType.Name:"土块",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.ToolType:Item.ToolType.Pickaxe,
		ItemInfoType.Texture2d:preload("uid://bkjw5whsctrkg")},
	1:{ItemInfoType.Name:"木头",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.ToolType:Item.ToolType.Axe,
		ItemInfoType.Texture2d:preload("uid://72n8y8dcb1lt")},
	2:{ItemInfoType.Name:"铁矿",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.ToolType:Item.ToolType.Pickaxe,
		ItemInfoType.Texture2d:preload("uid://b260pg6we3y46")},
	3:{ItemInfoType.Name:"铁锭",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.Texture2d:preload("uid://k4pbr8gjhnkj")},
	4:{ItemInfoType.Name:"橡实",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.Texture2d:preload("uid://b2ipcnwydr46h")},
	5:{ItemInfoType.Name:"凝胶",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.Texture2d:preload("uid://n4cmhfie58fg")},
	6:{ItemInfoType.Name:"火把",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp")},
	5000:{ItemInfoType.Name:"空手",
		ItemInfoType.Type:Item.ItemType.Tool,
		ItemInfoType.Texture2d:preload("uid://i6kp3chgcv2g"),
		ItemInfoType.ToolEfc:Vector3(30,30,30),
		ItemInfoType.ToolDurability:-1},
	5001:{ItemInfoType.Name:"铁镐",
		ItemInfoType.Type:Item.ItemType.Tool,
		ItemInfoType.Texture2d:preload("uid://mv88lde00dmn"),
		ItemInfoType.ToolEfc:Vector3(40,0,0),
		ItemInfoType.ToolDurability:20},
}

var array_items:Array[Item] = []

func _ready() -> void:
	append_item_nocheck(5000,1)
	append_item_quality(5001,2)
func append_item(new_item:Item):
	if check_item_change(new_item.item_id):
		var found:Item = find_item_get(new_item.item_id)
		if found:
			found.restore_quality(new_item.item_quality)
		else:
			array_items.append(new_item)
func append_item_nocheck(new_id:int,new_qua:int=1):
	var found:Item = find_item_get(new_id)
	if found:
		found.restore_quality(new_qua)
	else:
		var item:Item = get_item(new_id,new_qua)
		array_items.append(item)
func append_item_quality(new_id:int,new_qua:int=1):
	if check_item_change(new_id):
		var found:Item = find_item_get(new_id)
		if found:
			found.restore_quality(new_qua)
		else:
			var item:Item = get_item(new_id,new_qua)
			append_item(item)
func remove_item(new_item:Item):
	if check_item_change(new_item.item_id):
		var found:Item = find_item_get(new_item.item_id)
		if found:
			found.reduce_quality(new_item.item_quality)
func remove_item_quality(new_id:int,new_qua:int=1):
	if check_item_change(new_id):
		var found:Item = find_item_get(new_id)
		if found:
			found.reduce_quality(new_qua)
func append_items(array_item:Array[Vector2]):##id(int),qua(int)
	for ar in array_item:
		var new_item:Item = get_item(int(ar.x),int(ar.y))
		append_item(new_item)
func remove_items(array_item:Array[Vector2]):##id(int),qua(int)
	for ar in array_item:
		var new_item:Item = get_item(int(ar.x),int(ar.y))
		remove_item(new_item)
func find_item_has(it_id:int,qua:int=-1)->bool:
	var found:Item = find_item_get(it_id)
	if found:
		if qua == -1:
			return true
		else:
			if found.item_quality >= qua:
				return true
			else:
				return false
	return false
func find_item_get(it_id:int)->Item:
	for it in array_items:
		if it.item_id == it_id:
			return it
	return null
func get_item(new_id:int,new_qua:int=1)->Item:
	if new_id == -1:
		return null
	var item_info:Dictionary = ItemInfo.get(new_id)
	var item_type:Item.ItemType = item_info.get(ItemInfoType.Type)
	if item_type == Item.ItemType.Materials:
		var item:Item = Item.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type))
		item.item_quality = new_qua
		return item
	elif item_type == Item.ItemType.Tool:
		var item:ItemTool = ItemTool.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type))
		item.item_quality = new_qua
		item.tool_durability = item_info.get(ItemInfoType.ToolDurability)
		var item_toolEfc:Vector3 = get_item_info(new_id,ItemInfoType.ToolEfc)
		item.update_tool(item_toolEfc)
		return item
	return null
func get_all_items()->Array[Item]:
	return array_items
func get_items_show()->Array[Item]:
	var new_array:Array[Item] = []
	for it in array_items:
		if it.item_is_show:
			new_array.append(it)
	return new_array
func get_item_tools()->Array[Item]:
	var new_array:Array[Item] = []
	for it in array_items:
		if it.item_type == Item.ItemType.Tool:
			new_array.append(it)
	return new_array
func get_item_quality(new_id:int)->int:
	var item:Item = find_item_get(new_id)
	if item:
		return item.item_quality
	else:
		return 0
func get_item_bag()->ItemBagSlot:
	var item_slot:ItemBagSlot = ITEM_BAG.instantiate()
	return item_slot
func get_item_info(new_id:int,type:ItemInfoType=ItemInfoType.Null):##null返回全部信息-》Dictionary
	var item_info:Dictionary = ItemInfo.get(new_id)
	if type == ItemInfoType.Null:
		return item_info
	else:
		return item_info.get(type)
func check_item_change(item_id:int)->bool:
	if item_id in ItemNoRemoveList:
		return false
	else:
		return true
