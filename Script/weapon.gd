extends Item
class_name Weapon

# 武器專屬屬性
@export var base_damage: int = 0   # 基础傷害(物理，魔法，真实)
@export var crit_chance: float = 0.05  # 暴擊率
@export var knockback: float = 2.0     # 擊退
@export var rarity:float = 1.0
@export var interval_time: float = 0.5      # 攻速（越小越快）
@export_group("Bonus") ##vigor mind strength dexterity intelligence
@export var bonus_vigor:float = 0
@export var bonus_mind:float = 0
@export var bonus_strength:float = 1
@export var bonus_dexterity:float = 1
@export var bonus_intelligence:float = 1

func get_damage(player:Player=null)->float:
	var damage:float = base_damage
	if player:
		damage = get_damage_value(player)
	return damage
func get_damage_value(player:Player)->float: ##计算伤害的方法,计算加成
	var damage:float = (base_damage+bonus_strength*player.bonus_strength)
	damage += bonus_dexterity*player.bonus_dexterity
	damage += bonus_intelligence*player.bonus_intelligence
	damage = damage*(1+player.percentage_bonus)
	return damage
# 主動攻擊方法
func attack():
	var damage:float = get_damage()
	print("【%s】發動攻擊！造成 %d 傷害" % [item_name, damage])
	if randf() < crit_chance:
		print("→ 暴擊！傷害翻倍！")
	
