extends Item
class_name Weapon

@export var base_damage: float = 0   
@export var crit_chance: float = 0.05  # 暴擊率
@export var knockback: float = 2.0     # 擊退
@export var rarity:float = 1.0
@export var interval_time: float = 0.5      # 攻速
@export_group("Bonus") ##vigor mind strength dexterity intelligence
@export var bonus_vigor:float = 0
@export var bonus_mind:float = 0
@export var bonus_strength:float = 1
@export var bonus_dexterity:float = 1
@export var bonus_intelligence:float = 1

func update_info():
	pass
func get_damage(player:Player=null)->float:
	var damage:float = base_damage
	if player:
		damage = get_damage_value(player.character_data)
	return damage
func get_damage_value(player:PlayerData)->float: ##计算伤害的方法,计算加成
	var damage:float = (base_damage+bonus_strength*player.bonus_strength)
	damage += bonus_dexterity*player.bonus_dexterity
	damage += bonus_intelligence*player.bonus_intelligence
	damage = damage*(1+player.percentage_bonus)
	return damage
	
