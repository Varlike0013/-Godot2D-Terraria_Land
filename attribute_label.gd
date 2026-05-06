extends PanelContainer
class_name LabelAttribute

const ATTRIBUTE_RATING: Dictionary = { ##RANGE E->S
	"E": Vector2(0, 15),
	"D": Vector2(15, 30),
	"C": Vector2(30, 50),
	"B": Vector2(50, 75),
	"A": Vector2(75, 90),
	"S": Vector2(90, 100)
}

@onready var label_rating: Label = $MarginContainer/HBoxContainer/Label_rating
@onready var label_value: Label = $MarginContainer/HBoxContainer/Label_value
@onready var label_attribute: Label = $MarginContainer/HBoxContainer/Label_attribute
@onready var progress_bar: ProgressBar = $MarginContainer/HBoxContainer/ProgressBar

@export var attribut_name:String = ""

func _ready() -> void:
	label_attribute.text = attribut_name
	progress_bar.max_value = 100
func update(value_rating:float,value_current:float): ##todo update infomation from player,value_current->attribute_current_value like attribut_vigor
	label_rating.text = get_attribute_rating(value_rating)
	label_value.text = str(value_current)
	progress_bar.value = value_rating
## 函数：输入 float → 返回评级字符串
func get_attribute_rating(value: float) -> String:
	# 遍历字典，判断区间
	for grade in ATTRIBUTE_RATING:
		var range = ATTRIBUTE_RATING[grade]
		if value >= range.x and value < range.y:
			return grade
	return "S"    # 超出范围默认 S
