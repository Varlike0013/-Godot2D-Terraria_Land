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

func attribute_base_growth(attrribut_value: float,array_growth: Array[Vector2]) -> float:##返回具体数值如血量等
	var result: float = 0
	for i in range(array_growth.size()):
		var threshold: float = array_growth[i].x
		var add_per_level: float = array_growth[i].y
		var next_threshold: float = INF
		if i < array_growth.size() - 1:
			next_threshold = array_growth[i+1].x
		var points_in_range: float = clamp(attrribut_value, threshold, next_threshold) - threshold
		if points_in_range > 0:
			result += points_in_range * add_per_level
	return result
