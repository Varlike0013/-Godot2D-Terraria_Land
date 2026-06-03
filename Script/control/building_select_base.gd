extends PanelContainer
class_name BuildingSelectBase

const PRODUCTION_ITEM_MAKE = preload("uid://df3arr47xhg3x")
const PRODUCTION_SLOT_TOOL = preload("uid://d0k2blqno5lgk")

@onready var gdc_item: GridContainer = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/FoldableContainer/GDCItem
@onready var gdc_tool: GridContainer = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/FoldableContainer2/GDCTool
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCItem/VBoxContainer/ProgressBar
@onready var texture_rect_item: TextureRect = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCItem/VBoxContainer/MarginContainer/TextureRect
@onready var label_name: Label = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCItem/VBoxContainer/LabelName
@onready var label_quality: Label = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCItem/VBoxContainer/LabelQuality
@onready var label_interval: Label = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCItem/VBoxContainer/LabelInterval
@onready var texture_rect_tool: TextureRect = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCTool/VBoxContainer/MarginContainer/TextureRect
@onready var label_name_tool: Label = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCTool/VBoxContainer/LabelName
@onready var label_quality_tool: Label = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCTool/VBoxContainer/LabelQuality
@onready var label_durability: Label = $MarginContainer/HBoxContainer/CenterContainer/HBoxContainer/PCTool/VBoxContainer/LabelDurability

@export var array_items_id:Array[Vector3] = [] ##id(int),qua(int),time(float)

var current_building:BuildingProduction

func _ready() -> void:
	update(array_items_id)
func update(new_array:Array[Vector3]=[]):
	clear_slots()
	for cur in new_array:
		append_slot_item(int(cur.x),int(cur.y),cur.z)
	update_item_tool()
func update_item_tool():
	clear_tools()
	var array:Array[Item] = ManagerItem.get_item_tools()
	for cur in array:
		append_slot_tool(cur)
func append_slot_item(id:int,qua:int,time:float):
	var slot:ProductionItemMake = get_slot_item()
	gdc_item.add_child(slot)
	slot.update(id,qua,time)
func append_slot_tool(item_tool:Item):
	var slot:ProductionSlotTool = get_slot_tool()
	gdc_tool.add_child(slot)
	slot.update(item_tool)
func clear_slots():
	var chd:Array[Node] = gdc_item.get_children()
	for ch in chd:
		ch.queue_free()
func clear_tools():
	var chd:Array[Node] = gdc_tool.get_children()
	for ch in chd:
		ch.queue_free()
func get_slot_item()->ProductionItemMake:
	var slot:ProductionItemMake = PRODUCTION_ITEM_MAKE.instantiate()
	slot.Pressed.connect(_on_pressed_slot_item)
	return slot
func get_slot_tool()->ProductionSlotTool:
	var slot:ProductionSlotTool = PRODUCTION_SLOT_TOOL.instantiate()
	slot.Pressed.connect(_on_pressed_slot_tool)
	return slot
func update_show(): ##更新建筑信息到显示页面
	var item_id:int = current_building.production_item_id
	var tool_id:int = current_building.current_tool_id
	if item_id != -1:
		var item_quality:int = current_building.production_item_quality
		progress_bar.value = current_building.texture_progress_bar.value
		progress_bar.max_value  = current_building.texture_progress_bar.max_value
		texture_rect_item.texture = ManagerItem.get_item_info(item_id,ManagerItem.ItemInfoType.Texture2d)
		label_name.text = ManagerItem.get_item_info(item_id,ManagerItem.ItemInfoType.Name)
		label_quality.text = "x"+str(item_quality)+"("+str(ManagerItem.get_item_quality(item_id))+")"
	if tool_id != -1:
		var tool_durability:Vector2 = current_building.current_tool_durability
		texture_rect_tool.texture = ManagerItem.get_item_info(tool_id,ManagerItem.ItemInfoType.Texture2d) 
		label_name_tool.text = ManagerItem.get_item_info(tool_id,ManagerItem.ItemInfoType.Name)
		label_quality_tool.text = "x"+str(ManagerItem.get_item_quality(tool_id))
		if tool_durability.x<0:
			label_durability.text = "Infinite"
		else:
			label_durability.text = str(tool_durability.x)+"/"+str(tool_durability.y)
	var current_time:int = int(current_building.current_production_inteval*100)
	label_interval.text = str(float(current_time)/100)+"sec"
func _on_timer_update_timeout() -> void:
	if current_building:
		update_show()
func _on_pressed_slot_item(id:int,qua:int,time:float):
	current_building.update_item(id,qua,time)
func _on_pressed_slot_tool(item_tool:Item):
	if current_building:
		if current_building.current_tool_id != item_tool.item_id:
			current_building.return_tool()
			current_building.update_tool(item_tool)
			ManagerItem.remove_item_quality(item_tool.item_id)
