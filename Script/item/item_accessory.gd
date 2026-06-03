extends Item
class_name Accessory

# 飾品專屬被動屬性
@export var move_speed: float = 0.0    # 移動速度
@export var jump_height: float = 0.0   # 跳躍高度
@export var all_damage_bonus: float = 0.0  # 全傷加成
@export var can_fly: bool = false      # 能否飛行
@export var no_fall_damage: bool = false  # 免疫跌落傷害


func update_info():
	pass
func get_passive_bonus() -> Dictionary:
	return {
		move_speed = move_speed,
		jump_height = jump_height,
		all_damage = all_damage_bonus,
		can_fly = can_fly,
		no_fall = no_fall_damage
	}
