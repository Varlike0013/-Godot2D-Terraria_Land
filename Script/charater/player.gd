extends Character
class_name Player

@onready var area_2d_attack: Area2D = $Area2DAttack
@onready var collision_attack: CollisionShape2D = $Area2DAttack/CollisionShape2D
@onready var timer_attack: Timer = $TimerAttack

@export var distance_enemy:float = 10
@export_group("Attributes")
@export var attribute_strength:float = 10
@export var attribute_agile:float = 10
@export var attribute_physique:float = 10

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
