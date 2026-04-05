extends PanelContainer
class_name TopIndexBar

signal BeClicked

const TOP_INDEX_SLOT = preload("uid://bi6iqri2m8m6b")

@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var h_box_container: HBoxContainer = $ScrollContainer/HBoxContainer
@onready var timer_update: Timer = $TimerUpdate

@export var control_size:Vector2 = Vector2(1000,42)
@export var speed:float = 100

var hbar:HScrollBar
var offset_dis:float = 0
var direction_right:bool = true

func _ready() -> void:
	size = control_size
	hbar = scroll_container.get_h_scroll_bar()
func _physics_process(delta: float) -> void:
	if hbar.max_value>control_size.x:
		offset_dis = hbar.max_value-control_size.x
		if direction_right:
			hbar.value += delta*speed*(0.5+(offset_dis-hbar.value)/offset_dis/2)
		else:
			hbar.value -= delta*speed*(0.5+(offset_dis-hbar.value)/offset_dis/2)
		if hbar.value == offset_dis or hbar.value == 0:
			direction_right = !direction_right
func get_index_slots()->Array[TopIndexSlot]:
	var chd:Array = h_box_container.get_children()
	var new_array:Array[TopIndexSlot] = []
	for ch in chd:
		if ch is TopIndexSlot:
			new_array.append(ch)
	return new_array
func append_slot(item:Item):
	var slot:TopIndexSlot = TOP_INDEX_SLOT.instantiate()
	h_box_container.add_child(slot)
	slot.update(item)
func update():
	var array_items:Array[Item] = ManagerItem.get_items_show()
	var array_slots:Array[TopIndexSlot] = get_index_slots()
	var size_slots:int = array_slots.size()
	var size_items:int = array_items.size()
	if size_slots>size_items:
		for i in range(size_slots):
			if i<size_items:
				var current_slot:TopIndexSlot = array_slots.get(i)
				var current_item:Item = array_items.get(i)
				current_slot.update(current_item)
			else:
				var current_slot:TopIndexSlot = array_slots.get(i)
				current_slot.queue_free()
	elif size_slots<size_items:
		for i in range(size_items):
			if i<size_slots:
				var current_slot:TopIndexSlot = array_slots.get(i)
				var current_item:Item = array_items.get(i)
				current_slot.update(current_item)
			else:
				var current_item:Item = array_items.get(i)
				append_slot(current_item)
	else:
		for i in range(size_slots):
			var current_slot:TopIndexSlot = array_slots.get(i)
			var current_item:Item = array_items.get(i)
			current_slot.update(current_item)
func _on_button_button_down() -> void:
	BeClicked.emit()
func _on_timer_update_timeout() -> void:
	update()
