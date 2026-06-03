extends Item
class_name Armor

enum ArmorPart { HEAD, CHEST, LEGS }	##盔甲部位
enum ArmorGroup {NULL,Wooden}

@export var part: ArmorPart = ArmorPart.HEAD
@export var defense: float = 1.0       # 防禦
@export var group:ArmorGroup = ArmorGroup.NULL   # 套裝名稱

func update_info(armor_part:ArmorPart,armor_defense:int,armor_group:ArmorGroup) -> void:
	part = armor_part
	defense = armor_defense
	group = armor_group
func take_effect_armor_group():
	match group:
		ArmorGroup.NULL:pass
		ArmorGroup.Wooden: pass## todo list buffer player.defense += 1
