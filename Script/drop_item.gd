extends Node
class_name DropItem

@export var item_id:int = -1
@export var item_quality_min:int = 0
@export var item_quality_max:int = 0
@export_range(0,100,0.01) var item_drop_rate:float = 0 ##掉了概率

func get_drop_item()->Vector2:##id,quality
	var new_qua:int = item_quality_min
	for i in range(item_quality_max-item_quality_min):
		if randf_range(0,100)<item_drop_rate:
			new_qua += 1
	var info = Vector2(item_id,new_qua)
	return info
