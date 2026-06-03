extends Resource
class_name Item

enum ItemType {MATERIALS,WEAPON,TOOL,WEAPONTOOL,HEAD,CHEST,LEGGINGS, ACCESSORY,Coin}
enum ItemTool {NULL,PICKAXE,AXE,HAMMER}

var item_id:int
var item_texture:Texture2D
var item_name:String
var item_quality:int
var item_type:ItemType= ItemType.MATERIALS
var item_is_show:bool ##是否被显示在top_index
var item_description: String = "item description"

func _init(id:int,new_qua:int,table_row:TableItemRow) -> void:
	item_id = id
	item_quality = new_qua
	item_name = table_row.name
	item_texture = table_row.texture2d
	item_type = table_row.type
	item_description = table_row.description
func restore_quality(new_value:int):
	item_quality += new_value
func reduce_quality(new_value:int):
	item_quality -= new_value
	item_quality = max(0,item_quality)
