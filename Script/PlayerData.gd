extends CharacterData
class_name PlayerData

@export_group("Attributes")##vigor mind endurance strength dexterity intelligence
@export var attribute_vigor:float = 10 			##生命力
@export var vigor_health_base:float = 100
@export var vigor_health_growth:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]
@export var attribute_mind:float = 10  			##集中力
@export var mind_magic_base:float = 50
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
