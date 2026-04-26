extends Item
class_name Armor

# 盔甲部位（泰拉固定三部位）
enum ArmorPart { HEAD, CHEST, LEGS }

# 盔甲專屬屬性
@export var part: ArmorPart = ArmorPart.HEAD
@export var defense: int = 5           # 防禦
@export var class_bonus: float = 0.0  # 職業傷害加成（0.1 = +10%）
@export var set_name: String = ""      # 套裝名稱（熔岩套、星璇套...）

# 被動屬性加成
func get_bonus() -> Dictionary:
	return {
		defense = defense,
		damage_bonus = class_bonus,
		set_name = set_name
	}
