extends Item
class_name Weapon

# 武器專屬屬性
@export var damage: int = 10           # 傷害
@export var use_time: float = 0.5      # 攻速（越小越快）
@export var crit_chance: float = 0.05  # 暴擊率
@export var knockback: float = 2.0     # 擊退

# 主動攻擊方法
func attack():
	print("【%s】發動攻擊！造成 %d 傷害" % [item_name, damage])
	if randf() < crit_chance:
		print("→ 暴擊！傷害翻倍！")
		return damage * 2
	return damage
	
