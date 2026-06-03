extends StaticBody2D
class_name PylonPoint

const GroupTarget = "PylonPoint"
@export var health:Vector2 = Vector2(999,999)
@export var health_bar: HealthBar

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.add_to_group(GroupTarget)
	area_2d.collision_layer = 2+4
	area_2d.collision_layer = 2+4
	collision_layer = 2
	collision_layer = 2
func reduce_health(value:float):
	health.x -= value
	health.x = max(0,health.x)
func restore_health(value:float):
	health.x += value
	health.x = min(health.y,health.x)
func take_hit(damge:Vector3):
	reduce_health(damge.x)
	reduce_health(damge.y)
	reduce_health(damge.z)
