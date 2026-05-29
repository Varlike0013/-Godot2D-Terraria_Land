extends Weapon2D
class_name Sword

func attack_sword_broad(angle_start:float,angle_end:float,time:float,angle_effect:float=-1): ##angle_effect，触发特效时的角度range（start，end），-1表示不触发
	if is_attacking:
		return
	start_attack()
	change_angle(angle_start) #初始角度
	var tween:Tween = create_tween()
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
func attack_sword_short(angle_rad:float,distance:float,time:float):
	if  is_attacking:
		return
	start_attack()
	change_angle(angle_rad) #初始角度
	var original_position:Vector2 = position
	var target_position:Vector2 = original_position + Vector2(cos(angle_rad), sin(angle_rad)) * distance
	var tween:Tween = create_tween()
	tween.tween_property(self, "position", target_position, time / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	finish_attack()
	position = original_position
func _on_body_entered(body:Node2D):
	if body in damaged_enemies: ##如果对目标造成过一次伤害，不会造成第二次
		return
	if body is Character:
		body.take_hit(damage)
		damaged_enemies.append(body)
		print("position:",body.global_position.x, global_position.x)
		if body.global_position.x< global_position.x:
			body.effect_repeled(Vector2(-repeled.x,repeled.y))
		else:
			body.effect_repeled(repeled)
