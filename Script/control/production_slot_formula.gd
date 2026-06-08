extends PanelContainer
class_name ProductionSlotFormula

const PRODUCTION_ITEM_SLOT = preload("uid://boy5m3itr0gk5")

signal Pressed(current_formula:TableFormulaRow)

@onready var h_box_container: HBoxContainer = $ScrollContainer/HBoxContainer
@onready var h_box_input: HBoxContainer = $ScrollContainer/HBoxContainer/HBoxInput
@onready var h_box_output: HBoxContainer = $ScrollContainer/HBoxContainer/HBoxOutput
@onready var label_time: Label = $ScrollContainer/HBoxContainer/TextureRect/LabelTime

@export var current_formula:TableFormulaRow

func update(formula:TableFormulaRow):
	label_time.text = str(formula.time)+"sec"
	current_formula = current_formula
	for input:Vector2 in formula.input_items_id:
		var new_slot:ProductionItemSlot = get_slot()
		h_box_input.add_child(new_slot)
		new_slot.update(input)
	for output in formula.output_items_id:
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
			Pressed.emit(current_formula)
