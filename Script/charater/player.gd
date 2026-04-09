extends Character
class_name Player

@onready var area_2d_attack: Area2D = $Area2DAttack
@onready var collision_attack: CollisionShape2D = $Area2DAttack/CollisionShape2D
@onready var timer_attack: Timer = $TimerAttack

@export var distance_enemy:float = 10
@export_group("Attributes")
@export var attribute_vigor:float = 10 			##生命力
@export var vigor_health_base:float = 100
@export var vigor_health_growth:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]
@export var attribute_mind:float = 10  			##集中力
@export var mind_magic_base:float = 50
@export var mind_magic_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_endurance:float = 10 		##耐力
@export var endurance_equip_load:Vector2 = Vector2(0,10) ##负重
@export var endurance_equip_load_base:float = 10
@export var endurance_equip_load_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_strength:float = 10		##力量
@export var strength_scaling_base:float = 50	##力量补正
@export var strength_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_dexterity:float = 10  	##灵巧
@export var dexterity_scaling_base:float = 50
@export var dexterity_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_intelligence:float = 10 	##智力
@export var intelligence_scaling_base:float = 50
@export var intelligence_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]

var current_strength:float
var current_dexterity:float
var current_intelligence:float
var equips_array:Array = []
var enemys:Array[Enemy] = []

func _ready() -> void:
	super._ready()
	collision_attack.scale = attack_range*Vector2(1,1)
	area_2d_attack.collision_layer = 4
	area_2d_attack.collision_mask = 2
	area_2d_attack.area_entered.connect(_on_area_2d_attack_area_entered)
	area_2d_attack.area_exited.connect(_on_area_2d_attack_area_exited)
	area_2d_attack.body_entered.connect(_on_area_2d_attack_body_entered)
	area_2d_attack.body_exited.connect(_on_area_2d_attack_body_exited)
	timer_attack.wait_time = attack_inteval
	timer_attack.timeout.connect(_on_timer_attack_timeout)
func _physics_process(delta: float) -> void:
	if move_staus == MoveStaus.move:
		if attack_target:
			if position.x<attack_target.position.x+distance_enemy:
				linear_velocity.x = speed
				change_face_direction(false)
			elif position.x>attack_target.position.x-distance_enemy:
				linear_velocity.x = -speed
				change_face_direction(true)
			else :
				move_staus = MoveStaus.stand
		else:
			attack_target = level.get_nearest_enemy(global_position)
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
	if attack_target:
		if timer_attack.is_stopped():
			timer_attack.start()
	else:
		attack_target = get_area_enemy()
		if !attack_target:
			move_staus = MoveStaus.move
func get_area_enemy()->Enemy:
	for e in enemys:
		if e:
			return e
		else:
			enemys.erase(e)
	return null
func update_equip_load() ->void:
	endurance_equip_load.y = ManagerMath.attribute_base_growth(attribute_mind,mind_magic_base,mind_magic_growth)
func _on_area_2d_attack_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
func _on_area_2d_attack_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
func _on_area_2d_attack_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemys.append(body)
		move_staus = MoveStaus.stand
		attack_target = body
func _on_area_2d_attack_body_exited(body: Node2D) -> void:
	if body is Enemy:
		enemys.erase(body)
func _on_timer_attack_timeout() -> void:
	if attack_target:
		if attack_target is Enemy and attack_target in enemys:
			attack_target.take_hit(attack_damage)
func _on_timer_update() ->void:
	_on_timer_update.super()
	set_health_max(ManagerMath.attribute_base_growth(attribute_vigor,vigor_health_base,vigor_health_growth))
	set_magic_max(ManagerMath.attribute_base_growth(attribute_mind,mind_magic_base,mind_magic_growth))
	update_equip_load()
	current_strength = ManagerMath.attribute_base_growth(attribute_strength,strength_scaling_base,strength_scaling_growth)
	current_dexterity = ManagerMath.attribute_base_growth(attribute_dexterity,dexterity_scaling_base,dexterity_scaling_growth)
	current_intelligence = ManagerMath.attribute_base_growth(attribute_intelligence,intelligence_scaling_base,intelligence_scaling_growth)
