extends PanelContainer
class_name DisplayCharaterEquipment

@onready var v_box_container: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $MarginContainer/HBoxContainer/ScrollContainer/VBoxContainer2
@onready var panel_button: PanelContainer = $Control/PanelButton


var current_slot:EquipmentInfoLine

func _ready() -> void:
	panel_button.visible = false
	load_signal_connect()
func load_signal_connect():
	var chs:Array[Node] = v_box_container.get_children()
	chs.append_array(v_box_container_2.get_children())
	for ch in chs:
		if ch is EquipmentInfoLine:
			ch.clicked.connect(_on_slot_clicked)
func _on_slot_clicked(slot:EquipmentInfoLine):
	panel_button.visible = true
	current_slot = slot
