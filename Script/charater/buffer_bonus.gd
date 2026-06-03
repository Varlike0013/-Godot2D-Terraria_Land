extends Buffer
class_name BufferBonus

@export var defense:float = 1.0

func _on_take_effect()->void:
	if connect_player:
		connect_player.defense += defense
	
