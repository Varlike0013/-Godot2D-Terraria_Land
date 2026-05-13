extends RigidBody2D
class_name Character

enum MoveStaus {move,stop,stand,repeled}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label_top_info: Label = $Control/LabelTopInfo
@onready var health_bar: HealthBar = $Control/HealthBar

@export var level:Level
@export var default_direction:bool = true ##default_direction == Left && true
@export var move_staus:MoveStaus = MoveStaus.move
@export var group_target:String = "Character"
@export_group("BasicAttributes")
@export var charater_name: String = "name"
@export var charater_level: int = 1
@export var speed:float = 100
@export var health:Vector2 = Vector2(100,100) 
@export var magic:Vector2 = Vector2(50,50)
@export var defense:float = 0
@export var weight: float = 10
@export var is_fly:bool = false
@export var fly_higth:float = 50
@export_group("Percentage")
@export_range(0, 1) var percentage_resistance:float = 0 ##range in 【0-1】
@export_range(0, 1) var percentage_bonus:float = 0 ##range in 【0-1】
@export_group("Attack","attack")
@export var attack_damage:float = 0
@export var attack_range:float = 1
@export var attack_inteval:float = 1.0
@export var attack_target:Node2D
@export_group("Repeled")
@export var repeled_value:float = 10000 ##击退常数，决定被击退时的速度repeled_speed = repeled_value/weight
var repeled_speed:float = 0
var repeled_direction:Vector2 = Vector2.ZERO
var pylon_point:PylonPoint
@export_group("other")
var ray_cast:RayCast2D
var tween_hit:Tween
var timer_update:Timer
var resistance_array:Array[float] = []
var buffer_node:Node = Node.new()
var buffer_array:Array[Buffer] = []
var info_base:Dictionary = {}


func _ready() -> void:
	add_to_group(group_target)
	tween_hit = get_tree().create_tween().set_loops(0)
	tween_hit.tween_property(animated_sprite_2d,"modulate", Color(1, 0, 0), 0.15)
	tween_hit.tween_property(animated_sprite_2d,"modulate", Color(1, 1, 1), 0.1)
	tween_hit.pause()
	pylon_point = level.pylon_point
	lock_rotation = true
	collision_layer = 2##4表示会呗area检查到
	collision_mask = 1 ##1表示与场景碰撞，1+2表示与场景和自己碰撞
	add_child(buffer_node)
func _physics_process(delta: float) -> void:
	if move_staus == MoveStaus.move:
		if pylon_point:
			if pylon_point.position.x>position.x:
				linear_velocity.x = speed
				change_face_direction(false)
			else:
				linear_velocity.x = -speed
				change_face_direction(true)
	elif move_staus == MoveStaus.stand:
		linear_velocity.x = 0
		execute_stand()
	elif move_staus == MoveStaus.stop:
		linear_velocity = Vector2.ZERO
	elif move_staus == MoveStaus.repeled:
		linear_velocity = repeled_speed*repeled_direction
	if is_fly:
		var rounded:Vector2 = ray_get_round_position(fly_higth)
		if rounded:
			position.y = rounded.y-fly_higth
func execute_stand():
	pass
func change_face_direction(is_left:bool):
	if is_left:
		animated_sprite_2d.flip_h = !default_direction
	else:
		animated_sprite_2d.flip_h = default_direction
func ray_get_round_position(pos_y:float = 50)->Vector2:
	if !ray_cast:
		ray_cast = RayCast2D.new()
		add_child(ray_cast)
		ray_cast.target_position = Vector2(0,pos_y)
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return ray_cast.get_collision_point()
	else:
		return Vector2.ZERO
func get_face_dirtion() ->bool:##true is faced left
	return !(default_direction&&animated_sprite_2d.flip_h)
func effect_repeled(distance:float,repeled_left:bool=true,high:float=0,duration:float = 0,is_face:bool=false):
	##Parameter:距离，击退方向是否往左，时间，是否朝面向方向击退
	# 计算击退方向
	repeled_speed = repeled_value/weight
	move_staus = MoveStaus.repeled
	if duration == 0:
		duration = distance/repeled_speed
		duration = max(0.25,duration)
	if high!=0:
		repeled_direction.y = -(high/duration/repeled_speed)
	if is_face:# 根据角色面向方向决定击退方向
		if get_face_dirtion():
			repeled_direction.x = -1
		else:
			repeled_direction.x = -1
	else:# 根据 repeled_left 决定击退方向
		if repeled_left:
			repeled_direction.x = -1
		else:
			repeled_direction.x = 1
	await get_tree().create_timer(duration).timeout
	linear_velocity = Vector2.ZERO
	move_staus = MoveStaus.move
func effect_imprisonment(duration:float = 0.5):
	move_staus = MoveStaus.stop
	await get_tree().create_timer(duration).timeout
	move_staus = MoveStaus.move
func take_hit(value:float):
	if !tween_hit.is_running():
		tween_hit.play()
		await tween_hit.loop_finished
		tween_hit.pause()
	var real_value:float = (value-defense)*(1-percentage_resistance)
	reduce_health(real_value)
func get_all_info()->Dictionary:
	return {
		## charater_level speed health magic defense weight fly_higth
		"charater_level":charater_level,
		"speed":speed,
		"health":health,
		"magic":magic,
		"defense":defense,
		"weight":defense,
		"fly_higth":fly_higth,
		"attack_damage":attack_damage,
		"attack_inteval":attack_inteval,
		"attack_range":attack_range,
	}
func append_buffer(buffer:Buffer):
	buffer_node.add_child(buffer)
	buffer_array.append(buffer)
func remove_buffer(buffer:Buffer):
	buffer_node.remove_child(buffer)
	buffer_array.erase(buffer)
func get_buffer(is_array:bool = true)->Array[Buffer]:
	if is_array:
		return buffer_array
	var re_array:Array[Buffer] = []
	for nd in buffer_node.get_children():
		if nd is Buffer:
			re_array.append(nd)
	return re_array
func reduce_health(value:float):
	health.x -= value
	health.x = max(0,health.x)
	if health.x<=0:
		be_death()
func restore_health(value:float):
	health.x += value
	health.x = min(health.y,health.x)
func set_health_max(value:float):
	health.y = value
	if health.x>health.y:
		health.x = health.y
func reduce_magic(value:float):
	magic.x -= value
	magic.x = max(0,magic.x)
func restore_magic(value:float):
	magic.x += value
	magic.x = min(magic.y,magic.x)
func is_magic_enough(value:float) ->bool:
	if magic.x>=value:
		return true
	else:
		return false
func set_magic_max(value:float):
	magic.y = value
	if magic.x>magic.y:
		magic.x = magic.y
func be_death(): ##queue_free()
	queue_free()
func append_resistance_array(value:float): ##value in range(0,1)
	resistance_array.append(value)
func remove_resistance_array(value:float): ##value in range(0,1)
	resistance_array.erase(value)
func _on_timer_update(): ##to do for timer_update
	percentage_resistance = ManagerMath.resistance_array_to_percentage(resistance_array)
