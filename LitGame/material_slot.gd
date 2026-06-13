extends PanelContainer
class_name LTGMaterialSlot

@onready var texture_rect: TextureRect = $TextureRect
@onready var timer: Timer = $Timer

@export var item_id:int

func update(new_id:int,time:float=1.0):
	texture_rect.texture = ManagerItem.get_item_info(new_id).texture2d
	timer.start(time)
func _on_timer_timeout() -> void:
	pass # Replace with function body.
