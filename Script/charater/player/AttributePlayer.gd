extends Attribute
class_name AttributePlayer

@export var rating:float = 10.0

func attribute_base_growth(array_growth: Array[Vector2]) -> float:##返回具体数值如血量等
	var result: float = 0
	for i in range(array_growth.size()):
		var threshold: float = array_growth[i].x
		var add_per_level: float = array_growth[i].y
		var next_threshold: float = INF
		if i < array_growth.size() - 1:
			next_threshold = array_growth[i+1].x
		var points_in_range: float = clamp(current_value, threshold, next_threshold) - threshold
		if points_in_range > 0:
			result += points_in_range * add_per_level
	return result
func update_modifier_attribute(): ##need overrite for player's attribute
	pass
