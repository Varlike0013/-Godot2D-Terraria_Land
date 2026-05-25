extends Weapon2D
class_name Sword


func attack():
	attack_sword(deg_to_rad(-60), deg_to_rad(60), 0.3)
func attack_sword(angle_start: float, angle_end: float, time: float, angle_effect: float = -1): ##angle_effect，触发特效时的角度range（start，end），-1表示不触发
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
