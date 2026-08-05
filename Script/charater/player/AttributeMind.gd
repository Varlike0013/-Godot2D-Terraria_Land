extends AttributePlayer
class_name AttributeMind

@export_group("growth","growth")
@export var growth_magic:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]

func update_modifier_attribute(magci_max:Attribute):
	magci_max.add_modifier(Modifier.add("Attribute_Mind_Magic",attribute_base_growth(growth_magic)))
