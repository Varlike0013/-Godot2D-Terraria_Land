extends Control
class_name MobileControl

const KnobSize = Vector2(96,97)
const LimitPositonR = 90 ##限制移动半径
const LimitZoneR = 0.1 ##摇杆死区

@onready var actions: Control = $Actions
@onready var stick: Control = $Stick
@onready var other: Control = $Other

@onready var knob: TouchScreenButton = $Stick/Knob

@export var controll_actions:Control
@export var controll_knob:Control
@export var controll_other:Control

var finger_index:int = -1
var isKnobMove:bool = false

func set_knob_positon(new_pos:Vector2) ->Vector2:
	##start_pos圆心，LimitPositonR半径，限制新位置不超出范围
	var distance = new_pos.length()
	if distance > LimitPositonR:
		new_pos = new_pos.normalized()
		new_pos *= LimitPositonR
	knob.position = new_pos
	return new_pos
func set_controll_scale(new_value:float):
	controll_actions.scale = Vector2(new_value,new_value)
	controll_knob.scale = Vector2(new_value,new_value)
	controll_other.scale = Vector2(new_value,new_value)
func _input(event: InputEvent) -> void:
	var st := event as InputEventScreenTouch
	if st:
		if st.pressed and finger_index == -1 and isKnobMove:
			var new_pos:Vector2 = get_local_mouse_position() - stick.position - KnobSize/2
			set_knob_positon(new_pos)
			finger_index = st.index
		elif not st.pressed and st.index == finger_index:
			finger_index = -1
			set_knob_positon(Vector2(0,0))
			Input.action_release("ui_left")
			Input.action_release("ui_right")
			Input.action_release("ui_up")
			Input.action_release("ui_down")
	var sd := event as InputEventScreenDrag
	if sd and sd.index == finger_index:
		var new_pos:Vector2 = get_local_mouse_position() - stick.position - KnobSize/2
		var knob_positon:Vector2 = set_knob_positon(new_pos)
		var diretion:Vector2 = knob_positon.normalized()
		var strength:float = knob_positon.length()/LimitPositonR
		if strength<LimitZoneR:
			Input.action_release("ui_left")
			Input.action_release("ui_right")
			Input.action_release("ui_up")
			Input.action_release("ui_down")
		else:
			if diretion.x>0:
				Input.action_release("ui_left")
				Input.action_press("ui_right",strength)
			else :
				Input.action_release("ui_right")
				Input.action_press("ui_left",strength)
			if diretion.y>0:
				Input.action_release("ui_up")
				Input.action_press("ui_down",strength)
			else:
				Input.action_release("ui_down")
				Input.action_press("ui_up",strength)
func _on_touch_screen_button_x_pressed() -> void:
	Input.action_press("ui_interactive")
func _on_touch_screen_button_x_released() -> void:
	Input.action_release("ui_interactive")
func _on_touch_screen_button_a_pressed() -> void:
	print("pressed_a")
func _on_touch_screen_button_a_released() -> void:
	print("released_a")
func _on_knob_pressed() -> void:
	isKnobMove = true
func _on_knob_released() -> void:
	isKnobMove = false
func _on_touch_screen_button_close_pressed() -> void:
	actions.visible = !actions.visible
	stick.visible = !stick.visible
