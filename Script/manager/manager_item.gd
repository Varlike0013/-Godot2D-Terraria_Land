extends Node

enum ItemInfoType{Name,Texture2d,Type,Null,ToolEfc,ToolDurability,ToolUseType,Defense,ArmorGroup}

const ITEM_DATA_JSON = "res://Json/item_data.json"
const ITEM_BAG = preload("uid://bgosrqbnyvula")
const ItemNoRemoveList = [5000] ##无法被移除的物品的id
const ItemInfo:Dictionary = {
	0:{ItemInfoType.Name:"土块",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.Texture2d:preload("uid://bkjw5whsctrkg"),
		ItemInfoType.ToolUseType:Item.ToolType.Pickaxe},
	1:{ItemInfoType.Name:"木头",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.ToolUseType:Item.ToolType.Axe,
		ItemInfoType.Texture2d:preload("uid://72n8y8dcb1lt")},
	2:{ItemInfoType.Name:"铁矿",
		ItemInfoType.Type:Item.ItemType.Materials,
		ItemInfoType.ToolUseType:Item.ToolType.Pickaxe,
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
		ItemInfoType.Type:Item.ItemType.WEAPONTOOL,
		ItemInfoType.Texture2d:preload("uid://i6kp3chgcv2g"),
		ItemInfoType.ToolEfc:Vector3(30,30,30),
		ItemInfoType.ToolDurability:-1},
	5001:{ItemInfoType.Name:"铁镐",
		ItemInfoType.Type:Item.ItemType.WEAPONTOOL,
		ItemInfoType.Texture2d:preload("uid://mv88lde00dmn"),
		ItemInfoType.ToolEfc:Vector3(40,0,0),
		ItemInfoType.ToolDurability:20},
	6000:{ItemInfoType.Name:"木头盔",
		ItemInfoType.Type:Item.ItemType.HEAD,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp"),
		ItemInfoType.Defense:1,
		ItemInfoType.ArmorGroup:Armor.ArmorGroup.Wooden},
	6001:{ItemInfoType.Name:"木胸甲",
		ItemInfoType.Type:Item.ItemType.CHEST,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp"),
		ItemInfoType.Defense:1,
		ItemInfoType.ArmorGroup:Armor.ArmorGroup.Wooden},
	6002:{ItemInfoType.Name:"木护胫",
		ItemInfoType.Type:Item.ItemType.LEGGINGS,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp"),
		ItemInfoType.Defense:0,
		ItemInfoType.ArmorGroup:Armor.ArmorGroup.Wooden},
}

var array_items:Array[Item] = []

func _ready() -> void:
	append_item_nocheck(5000,1)
	append_item_quality(5001,2)
	append_item_quality(6000,1)
	append_item_quality(6001,1)
	append_item_quality(6002,1)
func load_items() -> Dictionary: ## 加载物品JSON 已弃用
	var file = FileAccess.open(ITEM_DATA_JSON, FileAccess.READ)
	if not file:
		return {}
	var json = JSON.new()
	var err = json.parse(file.get_as_text())
	file.close()
	if err != OK:
		printerr("JSON 错误:", json.get_error_message())
		return {}
	return json.data as Dictionary
func append_item(new_item:Item):
	if check_item_change(new_item.item_id):
		var found:Item = find_item_get(new_item.item_id)
		if found:
			found.restore_quality(new_item.item_quality)
		else:
			array_items.append(new_item)
func append_item_nocheck(new_id:int,new_qua:int=1): ##添加物品跳过检查步骤
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
		var item:Item = Item.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type),item_info.get(ItemInfoType.Name))
		item.item_quality = new_qua
		return item
	elif item_type == Item.ItemType.TOOL or item_type == Item.ItemType.WEAPONTOOL:
		var item:ItemTool = ItemTool.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type),item_info.get(ItemInfoType.Name))
		item.item_quality = new_qua
		item.tool_durability = item_info.get(ItemInfoType.ToolDurability)
		item.update_tool(get_item_info(new_id,ItemInfoType.ToolEfc))
		return item
	elif item_type == Item.ItemType.HEAD:
		var item:Armor = Armor.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type),item_info.get(ItemInfoType.Name))
		item.update_info(Armor.ArmorPart.HEAD,item_info.get(ItemInfoType.Defense),item_info.get(ItemInfoType.ArmorGroup))
		return item
	elif item_type == Item.ItemType.CHEST:
		var item:Armor = Armor.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type),item_info.get(ItemInfoType.Name))
		item.update_info(Armor.ArmorPart.CHEST,item_info.get(ItemInfoType.Defense),item_info.get(ItemInfoType.ArmorGroup))
		return item
	elif item_type == Item.ItemType.LEGGINGS:
		var item:Armor = Armor.new(new_id,item_info.get(ItemInfoType.Texture2d),item_info.get(ItemInfoType.Type),item_info.get(ItemInfoType.Name))
		item.update_info(Armor.ArmorPart.LEGS,item_info.get(ItemInfoType.Defense),item_info.get(ItemInfoType.ArmorGroup))
		return item
	return null
func get_all_items()->Array[Item]:
	return array_items
func get_item_type(need_type:Item.ItemType)->Array[Item]:
	var array:Array[Item] = []
	for ar in array_items:
		if ar.item_type == need_type:
			array.append(ar)
	return array
func get_items_show()->Array[Item]:
	var new_array:Array[Item] = []
	for it in array_items:
		if it.item_is_show:
			new_array.append(it)
	return new_array
func get_item_tools()->Array[Item]:
	var new_array:Array[Item] = []
	for it in array_items:
		if  it.item_type == Item.ItemType.TOOL or it.item_type == Item.ItemType.WEAPONTOOL:
			new_array.append(it)
	return new_array
func get_item_quality(new_id:int)->int:
	var item:Item = find_item_get(new_id)
	if item:
		return item.item_quality
	else:
		return 0
func get_remove_item(new_id:int,new_qua:int=1)->Item:
	if find_item_has(new_id,new_qua):
		remove_item_quality(new_id,new_qua)
		return get_item(new_id,new_qua)
	else:
		return null
func get_item_bag()->ItemBagSlot:
	var item_slot:ItemBagSlot = ITEM_BAG.instantiate()
	return item_slot
func get_item_info(new_id:int,type:ItemInfoType=ItemInfoType.Null):##null返回全部信息-》Dictionary
	var item_info:Dictionary = ItemInfo.get(new_id)
	if type == ItemInfoType.Null:
		return item_info
	else:
		return item_info.get(type)
func check_item_change(item_id:int)->bool: ##检查物品是否在ItemNoRemoveList，在其中无法被增减数量
	if item_id in ItemNoRemoveList:
		return false
	else:
		return true
func is_type_tool(type:Item.ItemType)->bool:
	if type == Item.ItemType.TOOL or type == Item.ItemType.WEAPONTOOL:
		return true
	else:
		return false
