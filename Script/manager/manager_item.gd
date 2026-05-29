extends Node

enum ItemInfoType{Name,Texture2d,Type,Null,ToolEfc,ToolDurability,ToolUseType,Defense,ArmorGroup,WeaponPacked}

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
	7:{ItemInfoType.Name:"铜币",
		ItemInfoType.Type:Item.ItemType.Coin,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp")},
	8:{ItemInfoType.Name:"银币",
		ItemInfoType.Type:Item.ItemType.Coin,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp")},
	9:{ItemInfoType.Name:"金币",
		ItemInfoType.Type:Item.ItemType.Coin,
		ItemInfoType.Texture2d:preload("uid://cpk7v5vjt26bp")},
	10:{ItemInfoType.Name:"铂金币",
		ItemInfoType.Type:Item.ItemType.Coin,
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
	7001:{ItemInfoType.Name:"木剑",
		ItemInfoType.Type:Item.ItemType.WEAPON,
		ItemInfoType.Texture2d:preload("uid://crcjp2nl3rim4"),
		ItemInfoType.WeaponPacked:preload("uid://dyd1flkcfn6uw")}
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
func append_items(array_item:Array[Vector2]):##id(int),qua(int)
	for ar in array_item:
		var new_item:Item = get_item(int(ar.x),int(ar.y))
		append_item(new_item)
func append_coin(value:int,type:int=0): ##0铜币，1银币，2金币，3铂金币
	append_item_quality(7+type,value)
func append_coin_value(value:int): ##添加货币，101，为1个银币1铜币，不看货币类型
	var arr:Array[int] = split_by_100_max_range(value)
	match arr.size():
		4 : append_coin(arr[0],3);append_coin(arr[1],2);append_coin(arr[2],1);append_coin(arr[3],0);
		3 : append_coin(arr[0],2);append_coin(arr[1],1);append_coin(arr[2],0);
		2 : append_coin(arr[0],1);append_coin(arr[1],0);
		1 : append_coin(arr[0],0);
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
func remove_items(array_item:Array[Vector2]):##id(int),qua(int)
	for ar in array_item:
		var new_item:Item = get_item(int(ar.x),int(ar.y))
		remove_item(new_item)
func remove_coin(value:int,type:int=0): ##0铜币，1银币，2金币，3铂金币
	var current:int = get_coin_number(type)
	if current>=value:
		remove_item_quality(7+type,value)
	else:
		remove_coin(7+type+1,1)
		append_coin(7+type,100)
		remove_coin(value,type)
func remove_coin_value(value:int): ##移除货币，101，为1个银币1铜币，不看货币类型
	if !find_coin_value(value):
		return
	var arr:Array[int] = split_by_100_max_range(value)
	match arr.size():
		4 : remove_coin(arr[0],3);remove_coin(arr[1],2);remove_coin(arr[2],1);remove_coin(arr[3],0);
		3 : remove_coin(arr[0],2);remove_coin(arr[1],1);remove_coin(arr[2],0);
		2 : remove_coin(arr[0],1);remove_coin(arr[1],0);
		1 : remove_coin(arr[0],0);
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
func find_coin_value(value:int)->bool:
	var current:int = get_coin_number()
	if current<value:
		return false
	else:
		return true
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
func get_coin_number(type:int=4)->int:##0铜币，1银币，2金币，3铂金币,4全部
	if type == 4:
		var coins:int = get_item_quality(7)+get_item_quality(8)*100
		coins += get_item_quality(9)*10000+get_item_quality(10)*1000000
		return coins
	else:
		return  get_item_quality(type)
func get_coin(type:int)->Item: ##0铜币，1银币，2金币，3铂金币
	var coin:Item = find_item_get(7+type)
	return coin
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
func split_by_100_max_range(num:int,times:int=4)->Array[int]: ##將一個數按每2位數分割，如123，輸出1,23
	var arr:Array[int] = []
	var count:int = 1
	while num>0:
		if count>=times:
			arr.append(num)
			break
		arr.append(num%100)
		num = int(num/100.0)
		count+=1
	return arr
