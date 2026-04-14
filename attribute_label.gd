extends PanelContainer
class_name LabelAttribute

@onready var label_rating: Label = $MarginContainer/HBoxContainer/Label_rating
@onready var label_value: Label = $MarginContainer/HBoxContainer/Label_value
@onready var h_slider: HSlider = $MarginContainer/HBoxContainer/HSlider
@onready var label_attribute: Label = $MarginContainer/HBoxContainer/Label_attribute

@export var attribut_name:String = ""

func _ready() -> void:
	label_attribute.text = attribut_name
func update(rat:String,value:Vector2):
	label_rating.text = rat
	label_value.text = str(value.x)+"/"+str(value.y)
	h_slider.value = value.x
	h_slider.max_value = value.y
