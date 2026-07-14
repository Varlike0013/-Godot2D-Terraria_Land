extends AttributePlayer
class_name  AttributeVigor

@export_group("growth","growth")
@export var growth_health:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]

func update_modifier_attribute():
	add_modifier(Modifier.add("Attribute_Vigor_Health",attribute_base_growth(growth_health)))
	
