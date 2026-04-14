extends PanelContainer
class_name LabelAttribute

@onready var label_rating: Label = $MarginContainer/HBoxContainer/Label_rating
@onready var label_value: Label = $MarginContainer/HBoxContainer/Label_value
@onready var h_slider: HSlider = $MarginContainer/HBoxContainer/HSlider
@onready var label_attribute: Label = $MarginContainer/HBoxContainer/Label_attribute

@export var attribut_name:String = ""

func _ready() -> void:
	label_attribute.text = attribut_name
	h_slider.max_value = 100
func update(rat:String,value_rating:float,value_current:float): ##todo update infomation from player,value_current->attribute_current_value like attribut_vigor
	label_rating.text = rat
	label_value.text = str(value_rating)+"/"+str(value_current)
	h_slider.value = value_rating

