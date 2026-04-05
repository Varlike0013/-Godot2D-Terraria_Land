extends StaticBody2D
class_name MysteriousPortal
@onready var animated_sprite_2d_door: AnimatedSprite2D = $AnimatedSprite2DDoor
@onready var animated_sprite_2d_eye: AnimatedSprite2D = $AnimatedSprite2DEye
@onready var timer_creater: Timer = $TimerCreater

@export var level:Level
@export var time_inteval:float = 15.0 ##默认15分钟一波，每波之间的每只间隔0.1秒
@export var range_inteval:float = 0.1
@export var enemy_array:Array[Array] = [] ##array[array[int]],波次：当前波次怪物的id，like:[[0,0,0,1][0,0,1,1]]

var current_range:int = 0

func _ready() -> void:
	collision_layer = 2
	collision_layer = 2
	timer_creater.wait_time = time_inteval
	timer_creater.timeout.connect(_on_timeout_creater)
	timer_creater.start()
func _on_timeout_creater():
	if current_range>= enemy_array.size():
		current_range = 0
	var array:Array = enemy_array.get(current_range)
	current_range += 1
	for ar in array:
		var enemy:Enemy = ManagerEnemy.get_enemy(ar)
		level.append_enemy(enemy,global_position)
		await get_tree().create_timer(range_inteval).timeout
