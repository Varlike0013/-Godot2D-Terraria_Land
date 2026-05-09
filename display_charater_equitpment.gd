extends PanelContainer
class_name DisplayCharaterEquipment

@onready var v_box_container: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer2


var current_slot:EquipmentInfoLine

func _ready() -> void:
	load_signal_connect()
func load_signal_connect():
	var chs:Array[Node] = v_box_container.get_children()
	chs.append_array(v_box_container_2.get_children())
