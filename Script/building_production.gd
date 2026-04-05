extends Control
class_name BuildingProduction

enum BuildingType {Base,Production}

signal Pressed(bd:BuildingProduction)

@onready var timer_production: Timer = $TimerProduction
@onready var texture_rect_background: TextureRect = $TextureRectBackground
@onready var texture_progress_bar: TextureProgressBar = $ItemPic/TextureProgressBar
@onready var texture_rect_item: TextureRect = $ItemPic/TextureRectItem
@onready var label_warning: Label = $ItemPic/LabelWarning

@export var control_size:Vector2 = Vector2(300,150)
@export var building_id:int = -1
@export var production_item_id:int = -1
@export var production_inteval:float = 1.0
@export var production_item_quality:int = 1
@export var building_type:BuildingType = BuildingType.Base

var building_row:BuildingRow
var current_production_inteval:float = 1.0
var current_items_input:Array[Vector2]
var current_items_output:Array[Vector2]
var current_item_tool_type:Item.ToolType
var current_tool_id:int = -1
var current_tool_durability:Vector2 = Vector2.ZERO
var current_tool_efc:Vector3

func _ready() -> void:
	custom_minimum_size = control_size
	timer_production.start()
func update_item(new_id:int,new_qua:int=1,new_itl:float=1.0):
	texture_rect_item.texture = ManagerItem.get_item_info(new_id,ManagerItem.ItemInfoType.Texture2d)
	production_item_id = new_id
	production_item_quality = new_qua
	production_inteval = new_itl
	current_item_tool_type =  ManagerItem.get_item_info(new_id,ManagerItem.ItemInfoType.ToolType)
	set_current_inteval()
	timer_production.start()
func update_tool(item_tool:Item):
	current_tool_id = item_tool.item_id
	current_tool_durability = Vector2(item_tool.tool_durability,item_tool.tool_durability)
	current_tool_efc = item_tool.get_tool_efficiency()
	set_current_inteval()
	timer_production.start()
func set_current_inteval():
	if current_item_tool_type == Item.ToolType.Pickaxe and current_tool_efc.x != 0:
		current_production_inteval = production_inteval/current_tool_efc.x*100
	elif current_item_tool_type == Item.ToolType.Axe and current_tool_efc.y != 0:
		current_production_inteval = production_inteval/current_tool_efc.y*100
	elif current_item_tool_type == Item.ToolType.Hammer and current_tool_efc.z != 0:
		current_production_inteval = production_inteval/current_tool_efc.z*100
	else:
		current_production_inteval = production_inteval/0.3
	texture_progress_bar.max_value = current_production_inteval
func update_production(time:float,array_in:Array[Vector2],array_out:Array[Vector2]):
	var item_show_id:int = int(array_out.get(0).x)
	texture_rect_item.texture = ManagerItem.get_item_info(item_show_id,ManagerItem.ItemInfoType.Texture2d)
	current_items_input = array_in
	current_items_output = array_out
	production_inteval = time
	texture_progress_bar.max_value = production_inteval
	timer_production.start()
func check_input_item(array_in:Array[Vector2])->bool:
	for ar in array_in:
		var found:bool = ManagerItem.find_item_has(int(ar.x),int(ar.y))
		if !found:
			return false
	return true
func return_tool():
	if current_tool_durability.x == current_tool_durability.y and current_tool_id!=-1:
		ManagerItem.append_item_quality(current_tool_id)
func remove_tool_durability(dra:float=1):
	if current_tool_id != -1:
		current_tool_durability.x -= dra
		if current_tool_durability.x<=0:
			if ManagerItem.find_item_has(current_tool_id,1):
				ManagerItem.remove_item_quality(current_tool_id)
				current_tool_durability.x = current_tool_durability.y
			else:
				current_tool_id = -1
func _on_button_button_down() -> void:
	Pressed.emit(self)
func _on_timer_production_timeout() -> void:
	if production_item_id != -1 or current_items_input.size()>0:
		if building_type == BuildingType.Base:
			texture_progress_bar.value += 0.1
		elif building_type == BuildingType.Production:
			if check_input_item(current_items_input):
				texture_progress_bar.value += 0.1
				label_warning.visible = false
			else:
				label_warning.visible = true
	if texture_progress_bar.value == texture_progress_bar.max_value:
		texture_progress_bar.value = 0
		if building_type == BuildingType.Base:
			var new_item:Item = ManagerItem.get_item(production_item_id,production_item_quality)
			ManagerItem.append_item(new_item)
			remove_tool_durability()
		elif building_type == BuildingType.Production:
			ManagerItem.remove_items(current_items_input)
			ManagerItem.append_items(current_items_output)
