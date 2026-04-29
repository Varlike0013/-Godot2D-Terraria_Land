extends Item
class_name Weapon

# 武器專屬屬性
@export var base_damage: Vector3 = Vector3(10,10,10)   # 基础傷害(物理，魔法，真实)
@export var crit_chance: float = 0.05  # 暴擊率
@export var knockback: float = 2.0     # 擊退
@export var rarity:float = 1.0
@export var interval_time: float = 0.5      # 攻速（越小越快）
@export_group("Bonus") ##vigor mind endurance strength dexterity intelligence
@export var bonus_vigor:float = 1
@export var bonus_mind:float = 1
@export var bonus_endurance:float = 1
@export var bonus_strength:float = 1
@export var bonus_dexterity:float = 1
@export var bonus_intelligence:float = 1

func get_damage(player:Player=null)->Vector3:
	var damage:Vector3 = base_damage
	if player:
		damage.x = get_damage_physical(player)*(1+player.percentage_physical_bonus)
		damage.y = get_damage_magic(player)*(1+player.percentage_magic_bonus)
		damage.z = get_damage_true(player)*(1+player.percentage_all_bonus)
	return damage
func get_damage_physical(player:Player)->float: ##计算伤害的方法,不计算加成，加成计算在get_damage()
	return (base_damage.x+bonus_strength*player.current_strength)
func get_damage_magic(player:Player)->float:
	return (base_damage.y+bonus_intelligence*player.current_intelligence)
func get_damage_true(player:Player)->float:
	return base_damage.z
# 主動攻擊方法
func attack():
	var damage:Vector3 = get_damage()
	print("【%s】發動攻擊！造成 %d 傷害" % [item_name, damage.x])
	if randf() < crit_chance:
		print("→ 暴擊！傷害翻倍！")
	
