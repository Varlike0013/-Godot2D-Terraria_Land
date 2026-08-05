extends CharacterData
class_name PlayerData

@export_group("Attributes")##vigor mind strength dexterity intelligence
@export var vigor:AttributeVigor				##生命力
@export var mind:AttributeMind					##集中力
@export var strength:AttributeStrength			##力量
@export var dexterity:AttributeDexterity		##灵巧
@export var intelligence:AttributeIntelligence	##智力

func update_attribute_modifier():
	vigor.update_modifier_attribute(health_max)
	mind.update_modifier_attribute(magic_max)
	strength.update_modifier_attribute()
	dexterity.update_modifier_attribute(armor)
	intelligence.update_modifier_attribute()
