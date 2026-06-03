extends Node
class_name Buffer  ##buffer base node 

enum Type {Timed,Count,Ever} ##timed随时间减少，Count计数,Ever永久

@export var buffer_id:int = -1
@export var buffer_name:String = "named"
@export var is_debuffer:bool = false
@export var buffer_type:Type = Type.Timed
@export var buffer_inteval:float = 1.0
@export var buffer_count:int = 1
@export var buffer_count_max:int = 10

var connect_player:Player
var timer:Timer

func _ready() -> void:
	if buffer_type == Type.Timed:
		timer = Timer.new()
		add_child(timer)
		timer.wait_time = buffer_inteval
		timer.timeout.connect(_on_buffer_time_out)
		timer.start()
func restore_count(value:int):
	buffer_count += value
	buffer_count = min(buffer_count,buffer_count_max)
func reduce_count(value:int):
	buffer_count -= value
	buffer_count = max(buffer_count,0)
func _on_take_effect()->void: ##接口 take effect
	pass
func _on_buffer_time_out()->void:
	reduce_count(1)
