extends RigidBody2D
class_name Character

const LAYER_SCENE  = 1  # 场景/地面
const LAYER_PLAYER = 2  # 玩家
const LAYER_ENEMY  = 4  # 敌人

enum MoveStatus { MOVE, STOP, STAND, REPELLED}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label_top_info: Label = $Control/LabelTopInfo
@onready var health_bar: HealthBar = $Control/HealthBar
@onready var timer_attack: Timer = $TimerAttack
@onready var area_2d_attack: Area2D = $Area2DAttack
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var level:Level
@export var pylon_point:PylonPoint
@export var character_data: CharacterData
@export var attack_target:Node2D
var move_status:MoveStatus = MoveStatus.MOVE
var repeled_direction:Vector2 = Vector2.ZERO
var tween_hit:Tween
var timer_update:Timer
var ray_cast:RayCast2D = RayCast2D.new()
var buffer_node:Node = Node.new()
var buffer_array:Array[Buffer] = []


func _ready() -> void:
	add_to_group(character_data.group_target)
	tween_hit = get_tree().create_tween().set_loops(0)
	tween_hit.tween_property(animated_sprite_2d,"modulate", Color(1, 0, 0), 0.15)
	tween_hit.tween_property(animated_sprite_2d,"modulate", Color(1, 1, 1), 0.1)
	tween_hit.pause()
	if level:
		pylon_point = level.pylon_point
	lock_rotation = true
	if area_2d_attack:
		area_2d_attack.scale = Vector2(character_data.attack_range,character_data.attack_range)
		area_2d_attack.body_entered.connect(_on_area_2d_attack_body_entered)
		area_2d_attack.body_exited.connect(_on_area_2d_attack_body_exited)
	if timer_attack:
		timer_attack.wait_time = character_data.attack_interval
		timer_attack.timeout.connect(_on_timer_attack_timeout)
	ray_cast.position = Vector2(0,-10)
	add_child(buffer_node)
	add_child(ray_cast)
func _physics_process(delta: float) -> void:
	if move_status == MoveStatus.MOVE:
		if is_ray_round(): ##在地面上
			if attack_target:
				if position.x<attack_target.position.x-character_data.attack_distance:
					linear_velocity.x = character_data.speed.current_value
					change_face_direction(false)
				elif position.x>attack_target.position.x+character_data.attack_distance:
					linear_velocity.x = -character_data.speed.current_value
					change_face_direction(true)
				else :
					move_status = MoveStatus.STAND
			else:
				attack_target = get_nearest()
		else:
			linear_velocity.x = 0
	elif move_status == MoveStatus.STAND:
		linear_velocity.x = 0
		execute_stand()
	elif move_status == MoveStatus.STOP:
		linear_velocity = Vector2.ZERO
	elif move_status == MoveStatus.REPELLED:
		linear_velocity = character_data.repeled_speed*repeled_direction
	if character_data.is_fly:
		var rounded:Vector2 = ray_get_round_position(character_data.fly_higth)
		if rounded:
			position.y = rounded.y-character_data.fly_higth
func execute_stand():
	pass
func change_face_direction(is_left:bool):
	if is_left:
		animated_sprite_2d.flip_h = !character_data.default_direction
	else:
		animated_sprite_2d.flip_h = character_data.default_direction
func ray_get_round_position(pos_y:float = 50)->Vector2:
	ray_cast.target_position = Vector2(0,pos_y)
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return ray_cast.get_collision_point()
	else:
		return Vector2.ZERO
func ray_get_round_distance(pos_y:float = 50)->float:
	ray_cast.target_position = Vector2(0,pos_y)
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return ray_cast.get_collision_point().distance_to(position)
	else:
		return -1
func is_ray_round(pos_y:float = 25)->bool:
	ray_cast.target_position = Vector2(0,pos_y)
	ray_cast.force_raycast_update()
	return ray_cast.is_colliding()
func get_face_dirtion() ->bool:##true is faced left
	return !(character_data.default_direction&&animated_sprite_2d.flip_h)
func get_nearest()->Node2D: ## return pylon or charater,player,enemy
	if self is Player:
		return get_nearest_for_player()
	elif  self is Enemy:
		return get_nearest_for_enemy()
	else:
		return null
func get_nearest_for_player()->Node2D:
	return null
func get_nearest_for_enemy()->Node2D:
	return null
func effect_repeled(direction:Vector2,duration:float = 0.25):
	##Parameter:击退方向和距离，击退时间
	move_status = MoveStatus.REPELLED
	repeled_direction.x = direction.x/duration
	repeled_direction.y = direction.y/(duration/2)
	await get_tree().create_timer(duration/2).timeout
	repeled_direction.y = 0
	await get_tree().create_timer(duration/2).timeout
	linear_velocity = Vector2.ZERO
	move_status = MoveStatus.MOVE
func effect_imprisonment(duration:float = 0.5):
	move_status = MoveStatus.STOP
	await get_tree().create_timer(duration).timeout
	move_status = MoveStatus.MOVE
func take_hit(value:float):
	if !tween_hit.is_running():
		tween_hit.play()
		await tween_hit.loop_finished
		tween_hit.pause()
	var real_value:float = character_data.calculate_damage(value)
	reduce_health(real_value)
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
	character_data.reduce_health(value)
	if character_data.health<=0:
		be_death()
func restore_health(value:float):
	character_data.restore_health(value)
func set_health_max(value:float):
	character_data.set_health_max(value)
func reduce_magic(value:float):
	character_data.reduce_magic(value)
func restore_magic(value:float):
	character_data.restore_magic(value)
func is_magic_enough(value:float) ->bool:
	return character_data.is_magic_enough(value)
func set_magic_max(value:float):
	character_data.set_magic_max(value)
func be_death(): ##queue_free()
	queue_free()
func append_resistance_array(value:float): ##value in range(0,1)
	character_data.append_resistance_array(value)
func remove_resistance_array(value:float): ##value in range(0,1)
	character_data.remove_resistance_array(value)
func _on_timer_update(): ##to do for timer_update
	pass
func _on_area_2d_attack_body_entered(body: Node2D) -> void:
	pass
func _on_area_2d_attack_body_exited(body: Node2D) -> void:
	pass
func _on_timer_attack_timeout():
	pass
