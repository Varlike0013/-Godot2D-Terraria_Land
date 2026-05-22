extends Character
class_name Enemy

@onready var drops: Node = $Drops

@export var coin_drop:Vector2 = Vector2.ZERO
var node_attacks:Array[Node2D] = []


func get_nearest_for_player()->Node2D:
	var result:Node2D = null
	if node_attacks.size()>0:
		result = get_node_attack()
		if result:
			return result
	if level:
		result = level.get_nearest_player(global_position)
		if result:
			return result
	if pylon_point:
		attack_target = pylon_point
	return result
func execute_stand():
	if timer_attack.is_stopped() and attack_target:
		timer_attack.start()
func get_node_attack()->Node2D:
	for nd in node_attacks:
		if nd:
			return nd
		else:
			node_attacks.erase(nd)
	return null
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
		var pos:Vector2 = self.global_position
		var dis:float = pos.distance_to(atl_tar.position)
		return dis
	elif attack_target:
		var pos:Vector2 = self.global_position
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
func drop_coin():
	var rand:int = randi_range(int(coin_drop.x),int(coin_drop.y))
	ManagerItem.append_coin_value(rand)
func be_death():
	drop_items()
	drop_coin()
	queue_free()
func _on_area_2d_acttack_area_entered(area: Area2D) -> void:
	pass
func _on_area_2d_acttack_area_exited(area: Area2D) -> void:
	pass
func _on_area_2d_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		node_attacks.append(body)
func _on_area_2d_attack_body_exited(body: Node2D) -> void:
	if body is Player:
		node_attacks.erase(body)
func _on_timer_attack_timeout() -> void:
	if attack_target is PylonPoint and attack_target in node_attacks:
		attack_effect()
