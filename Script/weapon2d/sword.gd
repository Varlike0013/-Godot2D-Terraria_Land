extends Weapon2D
class_name Sword


func attack():
	print("attack",self)
	attack_sword(deg_to_rad(-60), deg_to_rad(60), 0.3)
func attack_sword(angle_start: float, angle_end: float, time: float, angle_effect: float = -1):
	if is_attacking:
		return
	is_attacking = true
	damaged_enemies.clear()
	
	collision_shape.disabled = false
	monitoring = true
	monitorable = true
	rotation = angle_start
	
	var tween = create_tween()
	
	if angle_effect == -1:
		# 简单挥砍
		tween.tween_property(self, "rotation", angle_end, time)
		# 使用Timer持续检测
		await tween.finished
	else:
		# 带特效的挥砍
		tween.tween_property(self, "rotation", angle_effect, time / 2)
		await tween.finished
		attack_effect()
		tween = create_tween()
		tween.tween_property(self, "rotation", angle_end, time / 2)
		await tween.finished
	finish_attack()
func finish_attack():
	is_attacking = false
	damaged_enemies.clear()
	collision_shape.disabled = true
func _on_body_entered(body:Node2D):
	if body in damaged_enemies:
		return
	if body is Character:
		# 造成伤害
		body.take_hit(damage)
		damaged_enemies.append(body)
		# 击退
		if body.has_method("apply_knockback"):
			var direction = Vector2(cos(rotation), sin(rotation))
			#body.effect_repeled(direction * knockback_force) 实现击退
