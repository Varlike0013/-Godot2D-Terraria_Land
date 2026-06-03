extends PanelContainer
class_name HealthBar

enum HealthShowType {all,percentage,value}
@onready var progress_bar: ProgressBar = $HBoxContainer/ProgressBar
@onready var label: Label = $HBoxContainer/Label
@onready var timer: Timer = $Timer
@onready var label_top: Label = $TopInfo/LabelTop
@onready var top_info: Control = $TopInfo

@export var current_value:Vector2 = Vector2(10,10)##current/max
@export var bind_node:Node2D
@export var show_type:HealthShowType = HealthShowType.all
@export var time_inteval:float = 0.1

func _ready() -> void:
	label_top.visible = false
	update_show_type(ManagerSettings.is_show_health_bar)
	if bind_node is Enemy:
		current_value = bind_node.health
	elif bind_node is PylonPoint:
		current_value = bind_node.health
	timer.wait_time = time_inteval
	timer.start()
func update(new_value:Vector2):
	current_value = new_value
	update_show()
func update_show():
	progress_bar.max_value = current_value.y
	progress_bar.value = current_value.x
	label.text = str(current_value.x)+"/"+str(current_value.y)
func update_show_type(new_type:HealthShowType):
	show_type = new_type
	if show_type == HealthShowType.all:
		label.visible = true
		progress_bar.visible = true
	elif show_type == HealthShowType.percentage:
		label.visible = false
		progress_bar.visible = true
	elif show_type == HealthShowType.value:
		label.visible = true
		progress_bar.visible = false
func append_top_info(new_str:String):
	var new_label:Label = label_top.duplicate()
	new_label.text = new_str
	new_label.scale = Vector2(0,0)
	new_label.visible = true
	top_info.add_child(new_label)
	var tween:Tween = create_tween().set_loops(1)
	tween.tween_property(new_label,"scale",Vector2(0.85,0.85),0.3)
	tween.tween_property(new_label,"scale",Vector2(1,1),0.7)
	await tween.finished
	new_label.queue_free()
func _on_timer_timeout() -> void:
	if bind_node is Character:
		current_value = bind_node.health
	elif bind_node is PylonPoint:
		current_value = bind_node.health
	update_show_type(ManagerSettings.is_show_health_bar)
	update(current_value)
