extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready() -> void:
	while 1:
		await get_tree().create_timer(1.0).timeout
		if ray_cast_2d.is_colliding():
			print(ray_cast_2d.is_colliding(),ray_cast_2d.get_collision_point())
