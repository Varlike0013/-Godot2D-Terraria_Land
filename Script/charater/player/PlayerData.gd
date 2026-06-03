extends CharacterData
class_name PlayerData

@export_group("Attributes")##vigor mind strength dexterity intelligence
@export var vigor:float = 10 			##生命力
@export var vigor_base:float = 10
@export var vigor_health_growth:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]
@export var mind:float = 10  			##集中力
@export var mind_base:float = 10
@export var mind_magic_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_strength:float = 10		##力量
@export var strength_scaling_base:float = 50
@export var strength_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_dexterity:float = 10  	##灵巧
@export var dexterity_scaling_base:float = 50
@export var dexterity_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_intelligence:float = 10 	##智力
@export var intelligence_scaling_base:float = 50
@export var intelligence_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export_group("RantingValue") ##影响属性成长
@export var rating_value_vigor:float = 10
@export var rating_value_mind:float = 10
@export var rating_value_endurance:float = 10
@export var rating_value_strength:float = 10
@export var rating_value_dexterity:float = 10
@export var rating_value_intelligence:float = 10

func update_health():
	var result:float = health_base+(character_level-1)*level_growth_health
	result += attribute_base_growth(vigor,vigor_health_growth)
	set_health_max(result)
func update_magic():
	var result:float = magic_base+(character_level-1)*level_growth_magic
	result += attribute_base_growth(mind,mind_magic_growth)
	set_magic_max(result)
func update_attributes():
	##update vigor
	vigor = vigor_base+character_level
	pass
