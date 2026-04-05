extends Node
class_name Item

enum ItemType {Materials,Tool}
enum ToolType {Null,Pickaxe,Axe,Hammer}

var item_id:int
var item_texture:Texture2D
var item_name:String
var item_quality:int
var item_need_tool_type:ToolType = ToolType.Null
var item_type:ItemType = ItemType.Materials
var item_is_show:bool ##是否被显示在top_index

func _init(new_id:int,new_texture:Texture2D,type:ItemType) -> void:
	item_id = new_id
	item_texture = new_texture
	item_type = type
func restore_quality(new_value:int):
	item_quality += new_value
func reduce_quality(new_value:int):
	item_quality -= new_value
	item_quality = max(0,item_quality)
