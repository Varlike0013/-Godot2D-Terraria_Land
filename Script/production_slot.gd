extends PanelContainer
class_name ProductionSlot

const PRODUCTION_ITEM_SLOT = preload("uid://boy5m3itr0gk5")

signal Pressed(time:float,array_in:Array[Vector2],array_out:Array[Vector2])

@onready var h_box_container: HBoxContainer = $ScrollContainer/HBoxContainer
@onready var h_box_input: HBoxContainer = $ScrollContainer/HBoxContainer/HBoxInput
@onready var h_box_output: HBoxContainer = $ScrollContainer/HBoxContainer/HBoxOutput
@onready var label_time: Label = $ScrollContainer/HBoxContainer/TextureRect/LabelTime

@export var input_array:Array[Vector2] ##id&&quality
@export var output_array:Array[Vector2]##id&&quality
@export var product_time:float = 3.0 ##time_interval

func update(array_in:Array[Vector2],array_out:Array[Vector2],time:float):
	input_array = array_in
	output_array = array_out
	label_time.text = str(time)+"sec"
	for input:Vector2 in input_array:
		var new_slot:ProductionItemSlot = get_slot()
		h_box_input.add_child(new_slot)
		new_slot.update(input)
	for output in output_array:
		var new_slot:ProductionItemSlot = get_slot()
		h_box_output.add_child(new_slot)
		new_slot.update(output)
	size = h_box_container.size
func get_slot()->ProductionItemSlot:
	var new_slot:ProductionItemSlot = PRODUCTION_ITEM_SLOT.instantiate()
	return new_slot
func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			Pressed.emit(product_time,input_array,output_array)
