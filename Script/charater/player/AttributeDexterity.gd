extends AttributePlayer
class_name AttributeDexterity

@export_group("growth","growth")
@export var growth_amorr:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]

func update_modifier_attribute(amorr:Attribute):
	amorr.add_modifier(Modifier.add("Attribute_Dexterity_Amorr",attribute_base_growth(growth_amorr)))
