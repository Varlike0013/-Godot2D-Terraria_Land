extends Node
class_name Item

enum ItemType {Materials,WEAPON,TOOL,WEAPONTOOL,HEAD,CHEST,LEGGINGS, ACCESSORY }
enum ToolType{NULL,Pickaxe,Axe,Hammer}

var item_id:int
var item_texture:Texture2D
var item_name:String
var item_quality:int
var item_type:ItemType= ItemType.Materials
var item_use_tool:ToolType = ToolType.NULL #物品开采用的工具类型
var item_is_show:bool ##是否被显示在top_index
var item_description: String = "item description"

func _init(new_id:int,new_texture:Texture2D,type:ItemType,new_name:String) -> void:
	item_id = new_id
	item_name = new_name
	item_texture = new_texture
	item_type = type
func restore_quality(new_value:int):
	item_quality += new_value
func reduce_quality(new_value:int):
	item_quality -= new_value
	item_quality = max(0,item_quality)
