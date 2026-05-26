extends Weapon2D
class_name Spear

func attack(glo_pos:Vector2):
	pass ##attack_spear()
func attack_spear(angle: float, distance: float, time: float):
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
	# 前刺
	tween.tween_property(self, "position", target_position, time / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	# 在戳刺过程中检查伤害
	tween.tween_callback(func():
		check_damage()
	)
	# 收回
	tween.tween_property(self, "position", original_position, time / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		is_attacking = false
		has_hit = false
		collision_shape.disabled = true  # 攻击结束后禁用碰撞
		tween.queue_free()
	)
	await get_tree().create_timer(cooldown).timeout
	can_attack = true
func check_damage():
	if has_hit:
		return
	has_hit = true
	# Area2D 可以直接调用 get_overlapping_bodies()
	var overlapping_bodies:Array[Node2D] = get_overlapping_bodies()
	var overlapping_areas:Array[Area2D] = get_overlapping_areas()
	# 伤害物理体（如 CharacterBody2D, RigidBody2D）
	for body in overlapping_bodies:
		if body is Character:
			body.take_hit(damage)
	# 也可以伤害其他 Area2D（如敌人的伤害区域）
	#for area in overlapping_areas:
		#if area.has_method("damage"):
			#area.damage(spear_damage)
