extends Weapon2D
class_name Sword

func attack(glo_pos:Vector2):
	var direction:Vector2 = global_position.direction_to(glo_pos)
	var angle_rad: float = direction.angle()
	if weapon_type == WeaponType.BroadSword:
		if attack_diretion(angle_rad):
			attack_sword_broad(deg_to_rad(-105), deg_to_rad(75), 0.3)
		else:
			attack_sword_broad(deg_to_rad(15), deg_to_rad(-165), 0.3)
	elif weapon_type == WeaponType.ShortSword:
		attack_sword_short(angle_rad,10,0.3)
func attack_sword_broad(angle_start:float,angle_end:float,time:float,angle_effect:float=-1): ##angle_effect，触发特效时的角度range（start，end），-1表示不触发
	if is_attacking:
		return
	is_attacking = true
	damaged_enemies.clear()
	
	collision_shape.disabled = false
	monitoring = true
	monitorable = true
	change_angle(angle_start) #初始角度
	
	var tween = create_tween()
	
	if angle_effect == -1: ##基础挥击
		tween.tween_property(self, "rotation", angle_end, time)
		await tween.finished
	else:# 带特效的挥砍
		tween.tween_property(self, "rotation", angle_effect, time / 2)
		await tween.finished
		attack_effect()
		tween = create_tween()
		tween.tween_property(self, "rotation", angle_end, time / 2)
		await tween.finished
	finish_attack()
func attack_sword_short(angle:float,distance:float,time:float):
	if not can_attack or is_attacking:
		return
	can_attack = false
	is_attacking = true
	has_hit = false
	var original_position:Vector2 = position
	var target_position:Vector2 = original_position + Vector2(cos(angle), sin(angle)) * distance
	rotation = angle
	# 确保碰撞检测启用
	collision_shape.disabled = false
	monitoring = true
	monitorable = true
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, time / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position", original_position, time / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		finish_attack()
		tween.queue_free()
	)
	await get_tree().create_timer(cooldown).timeout
	can_attack = true
func finish_attack():
	is_attacking = false
	damaged_enemies.clear()
	collision_shape.disabled = true
func _on_body_entered(body:Node2D):
	if body in damaged_enemies:
		return
	if body is Character:
		body.take_hit(damage)
		damaged_enemies.append(body)
		if body.has_method("effect_repeled"):
			body.effect_repeled(Vector2(500,-500))
