extends Node2D
class_name DropItem2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var item_id:int

func update(id:int):
	item_id = id
	sprite_2d.texture = ManagerItem.get_item_info(item_id,ManagerItem.ItemInfoType.Texture2d)
func be_drop():
	var tween:Tween = create_tween().set_loops(1)
	scale = Vector2(0,0)
	tween.tween_property(self,"scale",Vector2(1,1),0.33)
	tween.tween_property(self,"scale",Vector2(1,1),0.33)
	tween.tween_property(self,"scale",Vector2(0,0),0.33)
	await  tween.finished
	queue_free()
