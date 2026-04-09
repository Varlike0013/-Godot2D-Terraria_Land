extends Node
class_name Equipment

@export var strength_bonus: float = 0
@export var dexterity_bonus: float = 0
@export var intelligence_bonus: float = 0

var connect_player:Player

func get_damage()->Vector3:
	var result:Vector3 = Vector3(0,0,0)
	if connect_player:
		pass
	return result
