extends CanvasLayer
class_name LevelUi

@onready var top_index_bar: TopIndexBar = $UI_Play/TopIndexBar
@onready var ui_play: Control = $UI_Play
@onready var ui_bag: Control = $UI_Bag
@onready var ui_create: Control = $UI_Create
@onready var ui_select: Control = $UI_Select
@onready var grid_container_slots: GridContainer = $UI_Bag/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer
@onready var grid_container_create: GridContainer = $UI_Create/MarginContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer
@onready var building_select_base: BuildingSelectBase = $UI_Select/MarginContainer/BuildingSelectBase
@onready var building_select_product: BuildingSelectProduction = $UI_Select/MarginContainer/BuildingSelect
@onready var timer_flash: Timer = $UI_Bag/Control/HBoxContainer/CB_flash/TimerFlash
@onready var top_info: Control = $UI_Top/TopInfo
@onready var top_info_show: PanelContainer = $UI_Top/TopInfo/TopInfoShow

@export var camera2d:Camera2D

var selected_row:BuildingRow

func _ready() -> void:
	load_items()
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		camera2d.position.x -= 100*delta*Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_right"):
		camera2d.position.x += 100*delta*Input.get_action_strength("ui_right")
	if Input.is_action_pressed("ui_up"):
		camera2d.position.y -= 100*delta*Input.get_action_strength("ui_up")
	if Input.is_action_pressed("ui_down"):
		camera2d.position.y += 100*delta*Input.get_action_strength("ui_down")
func add_item_bag(item:Item):
	var slot:ItemBagSlot = ManagerItem.get_item_bag()
	grid_container_slots.add_child(slot)
	slot.update(item)
func add_building_slot(new_id:int):
	var slot:BuildingSlot = ManagerBuilding.get_building_slot()
	grid_container_create.add_child(slot)
	slot.update(new_id)
	slot.Pressed.connect(_on_pressed_create_slot)
func get_item_slots() ->Array[ItemBagSlot]:
	var nodes:Array = grid_container_slots.get_children()
	var array:Array[ItemBagSlot] = []
	for nd in nodes:
		if nd is ItemBagSlot:
			array.append(nd)
	return array
func get_building_slots() ->Array[BuildingSlot]:
	var nodes:Array = grid_container_create.get_children()
	var array:Array[BuildingSlot] = []
	for nd in nodes:
		if nd is BuildingSlot:
			array.append(nd)
	return array
func append_top_info(new_info:String,time_move:float=0.5,time_clear:float=0.5):
	var node: = top_info_show.duplicate()
	var chd:Node = node.get_child(0)
	if chd is Label:
		var new_label:Label = chd
		new_label.text = new_info
		top_info.add_child(node)
		top_info_show.visible = true
		var tween:Tween = create_tween().set_loops(1)
		var new_pos:Vector2 = top_info_show.position - Vector2(0,50)
		tween.tween_property(top_info_show,"position",new_pos,time_move)
		tween.tween_property(top_info_show,"modulate:a",0,time_clear)
		await tween.finished
		top_info_show.queue_free()
func clear_building_slots():
	var nodes:Array = grid_container_create.get_children()
	for nd in nodes:
		if nd is BuildingSlot:
			nd.queue_free()
func load_items():
	var array:Array = ManagerItem.get_all_items()
	for it:Item in array:
		add_item_bag(it)
func update_items():
	var array_items:Array = ManagerItem.get_all_items()
	var array_slots:Array = get_item_slots()
	var size_slots:int = array_slots.size()
	var size_items:int = array_items.size()
	if size_slots>size_items:
		for i in range(size_slots):
			if i<size_items:
				var current_slot:ItemBagSlot = array_slots.get(i)
				var current_item:Item = array_items.get(i)
				current_slot.update(current_item)
			else:
				var current_slot:ItemBagSlot = array_slots.get(i)
				current_slot.queue_free()
	elif size_slots<size_items:
		for i in range(size_items):
			if i<size_slots:
				var current_slot:ItemBagSlot = array_slots.get(i)
				var current_item:Item = array_items.get(i)
				current_slot.update(current_item)
			else:
				var current_item:Item = array_items.get(i)
				add_item_bag(current_item)
	else:
		for i in range(size_slots):
			var current_slot:ItemBagSlot = array_slots.get(i)
			var current_item:Item = array_items.get(i)
			current_slot.update(current_item)
func update_create():
	clear_building_slots()
	var info_dic:Dictionary = ManagerBuilding.get_building_dic()
	for info in info_dic:
		add_building_slot(info)
func update_select(new_bd:BuildingProduction):
	if new_bd.building_type == BuildingProduction.BuildingType.Base:
		building_select_base.visible = true
		var array:Array[Vector3] = ManagerBuilding.get_building_production(new_bd.building_id)
		building_select_base.update(array)
		building_select_base.current_building = new_bd
		building_select_product.visible = false
	elif new_bd.building_type == BuildingProduction.BuildingType.Production:
		building_select_base.visible = false
		var array:Array[Dictionary] = ManagerBuilding.get_building_make(new_bd.building_id)
		building_select_product.update(array)
		building_select_product.current_building = new_bd
		building_select_product.visible = true
func _on_pressed_create_slot(id:int) ->void:
	if selected_row:
		selected_row.append_building(id)
		ui_create.visible = false
func _on_top_index_bar_be_clicked() -> void:
	ui_bag.visible = true
func _on_h_slider_value_changed(value: float) -> void:
	var new_zoom:float = value/100
	camera2d.zoom = Vector2(1+new_zoom,1+new_zoom)
func _on_bt_bag_button_down() -> void:
	update_items()
	ui_bag.visible = true
func _on_bt_exit_button_down() -> void:
	ui_bag.visible = false
func _on_bt_flash_button_down() -> void:
	update_items()
func _on_bt_create_exit_button_down() -> void:
	ui_create.visible = false
func _on_bt_select_exit_button_down() -> void:
	ui_select.visible = false
func _on_cb_flash_toggled(toggled_on: bool) -> void:
	if toggled_on:
		timer_flash.start()
	else:
		timer_flash.stop()
func _on_timer_flash_timeout() -> void:
	update_items()
