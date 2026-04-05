extends Character
class_name Enemy

@onready var timer_attack: Timer = $TimerAttack
@onready var area_2d_acttack: Area2D = $Area2DActtack
@onready var drops: Node = $Drops
@onready var collision_self: CollisionShape2D = $CollisionShape2D
@onready var collision_attack: CollisionShape2D = $Area2DActtack/CollisionShape2D

var collision_acttack_position:Vector2
var collision_self_positon:Vector2
var area_nodes:Array = []

func _ready() -> void:
	super._ready()
	area_2d_acttack.collision_layer = 4
	area_2d_acttack.collision_mask = 2
	area_2d_acttack.area_entered.connect(_on_area_2d_acttack_area_entered)
	area_2d_acttack.area_exited.connect(_on_area_2d_acttack_area_exited)
	timer_attack.timeout.connect(_on_timer_attack_timeout)
	timer_attack.wait_time = attack_inteval
	collision_acttack_position = collision_attack.position
	collision_self_positon = collision_self.position
	collision_attack.scale = attack_range*Vector2(1,1)
func execute_stand():
	if timer_attack.is_stopped() and attack_target:
		timer_attack.start()
func attack_effect():
	#@creater_bullet
	#var bullet:Bullet = ManagerProjectile.get_projectiles_id(0)
	#bullet.target = pylon_point
	#bullet.position = position
	#level.append_projectile(bullet)
	if attack_target:
		if attack_target is Character:
			health_bar.append_top_info("攻击造成："+str(attack_damage)+"伤害！")
			attack_target.take_hit(attack_damage)
		elif attack_target is PylonPoint:
			health_bar.append_top_info("攻击造成："+str(attack_damage)+"伤害！")
			attack_target.take_hit(attack_damage)
func attack_target_distance(atl_tar:Node2D=null) ->float:
	if atl_tar:
		var pos:Vector2 = collision_attack.global_position
		var dis:float = pos.distance_to(atl_tar.position)
		return dis
	elif attack_target:
		var pos:Vector2 = collision_attack.global_position
		var dis:float = pos.distance_to(attack_target.position)
		return dis
	else:
		return 0
func is_in_attack_ranged(atl_tar:Node2D=null)->bool:
	var dis = attack_target_distance(atl_tar)
	if dis>0 and dis<attack_range:
		return true
	else:
		return false
func is_attack_range_dur()->bool:
	return true
func change_face_direction(is_left:bool):
	if is_left:
		animated_sprite_2d.flip_h = !default_direction
		collision_self.position = collision_self_positon
		collision_attack.position = collision_acttack_position
	else:
		animated_sprite_2d.flip_h = default_direction
		collision_attack.position.x = -collision_acttack_position.x
		collision_self.position.x = -collision_self_positon.x
func get_drops_array()->Array[DropItem]:
	var nodes:Array[Node] = drops.get_children()
	var new_array:Array[DropItem] = []
	for nd in nodes:
		if nd is DropItem:
			new_array.append(nd)
	return new_array
func get_drops()->Array[Vector2]:
	var drop_array:Array[DropItem] = get_drops_array()
	var drops_current:Array[Vector2] = []
	for dr in drop_array:
		drops_current.append(dr.get_drop_item())
	return drops_current
func drop_items():
	var drops_vec:Array[Vector2] = get_drops()
	for dr in drops_vec:
		level.append_drops(int(dr.x),global_position)
	ManagerItem.append_items(drops_vec)
func be_death():
	drop_items()
	queue_free()
func _on_area_2d_acttack_area_entered(area: Area2D) -> void:
	if area.is_in_group(PylonPoint.GroupTarget):
		var point:PylonPoint = area.get_parent()
		area_nodes.append(point)
		move_staus = MoveStaus.stand
		attack_target = point
func _on_area_2d_acttack_area_exited(area: Area2D) -> void:
	if area.is_in_group(PylonPoint.GroupTarget):
		var point:PylonPoint = area.get_parent()
		area_nodes.erase(point)
func _on_timer_attack_timeout() -> void:
	if attack_target is PylonPoint and attack_target in area_nodes:
		attack_effect()
