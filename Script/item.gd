extends Node
class_name Item

enum ItemType {Materials,Pickaxe,Axe,PickAaxe,HamAxe,Hammer,WEAPON,HEAD,CHEST,LEGGINGS, ACCESSORY }

var item_id:int
var item_texture:Texture2D
var item_name:String
var item_quality:int
var item_type:ItemType= ItemType.Materials
var item_use_tool:ItemType = ItemType.Pickaxe
var item_is_show:bool ##是否被显示在top_index
var item_description: String = "item description"

func _init(new_id:int,new_texture:Texture2D,type:ItemType) -> void:
	item_id = new_id
	item_texture = new_texture
	item_type = type
func restore_quality(new_value:int):
	item_quality += new_value
func reduce_quality(new_value:int):
	item_quality -= new_value
	item_quality = max(0,item_quality)
func is_type_tool()->bool:
	if item_type == ItemType.Pickaxe or item_type == ItemType.Axe or item_type == ItemType.PickAaxe:
		return true
	elif item_type == ItemType.HamAxe or item_type == ItemType.Hammer:
		return true
	else:
		return false
