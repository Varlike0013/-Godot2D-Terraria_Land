extends Resource
class_name CharacterData

@export var default_direction: bool = true   ##default_direction == Left && true
@export var group_target: String = "Character"
@export var character_name: String = "name"
@export_group("BasicAttributes")
@export var speed: float = 100.0
@export var health: Vector2 = Vector2(100, 100)    # (当前HP, 最大HP)
@export var magic: Vector2 = Vector2(50, 50)       # (当前MP, 最大MP)
@export var defense: float = 0.0 ##固定减伤
@export var bonus:float = 0.0 ##固定增伤
@export var weight: float = 10.0
@export var is_fly: bool = false
@export var fly_height: float = 50.0
@export_group("level")
@export var character_level: int = 1
@export var level_health_base:float = 100.0
@export var level_health_growth:float = 10.0
@export var level_magic_base:float = 50.0
@export var level_magic_growth:float = 5.0
@export_group("Percentage")
@export_range(0, 1) var percentage_resistance: float = 0.0 ##百分减伤
@export_range(0, 1) var percentage_bonus: float = 0.0 ##百分比增伤
@export_group("Attack", "attack")
@export var attack_distance: float = 50.0
@export var attack_damage: float = 0.0
@export var attack_range: float = 1.0
@export var attack_interval: float = 1.0
@export_group("Repelled")
@export var repeled_speed: float = 1.0 ##击退常数，决定被击退时的速度repeled_speed = repeled_value/weight
var resistance_array:Array[float] = []
var bonus_array:Array[float] = []

func reduce_health(value:float):
	health.x -= value
	health.x = max(0,health.x)
func restore_health(value:float):
	health.x += value
	health.x = min(health.y,health.x)
func set_health_max(value:float):
	health.y = value
	if health.x>health.y:
		health.x = health.y
func update_health():
	set_health_max(level_health_base+(character_level-1)*level_health_growth)
func reduce_magic(value:float):
	magic.x -= value
	magic.x = max(0,magic.x)
func restore_magic(value:float):
	magic.x += value
	magic.x = min(magic.y,magic.x)
func update_magic():
	set_magic_max(level_magic_base+(character_level-1)*level_magic_growth)
func is_magic_enough(value:float) ->bool:
	if magic.x>=value:
		return true
	else:
		return false
func set_magic_max(value:float):
	magic.y = value
	if magic.x>magic.y:
		magic.x = magic.y
func calculate_damage(value: float) -> float:
	var after_defense = max(value+bonus-defense, 0.0)
	var resist = clamp(percentage_resistance, 0.0, 1.0)
	var pbonus = clamp(percentage_bonus, 0.0, 1.0)
	var final_damage = after_defense * (1.0 - resist)*(1.0+pbonus)
	if final_damage > 0.0 and final_damage < 1.0:
		final_damage = 1.0
	return final_damage
func append_resistance_array(value:float): ##value in range(0,1)
	resistance_array.append(value)
func remove_resistance_array(value:float): ##value in range(0,1)
	resistance_array.erase(value)
func update_resistance():
	percentage_resistance = resistance_array_to_percentage(resistance_array)
func append_bonus_array(value:float): ##value in range(0,1)
	bonus_array.append(value)
func remove_bonus_array(value:float): ##value in range(0,1)
	bonus_array.erase(value)
func update_bonus():
	percentage_bonus = resistance_array_to_percentage(bonus_array)
func resistance_array_to_percentage(array:Array[float]): ##return in range(0,1)
	var result:float = 1.0
	for ar in array:
		result = result*(1.0-ar)
	return result
func attribute_base_growth(attrribut_value: float,array_growth: Array[Vector2]) -> float:##返回具体数值如血量等
	var result: float = 0
	for i in range(array_growth.size()):
		var threshold: float = array_growth[i].x
		var add_per_level: float = array_growth[i].y
		var next_threshold: float = INF
		if i < array_growth.size() - 1:
			next_threshold = array_growth[i+1].x
		var points_in_range: float = clamp(attrribut_value, threshold, next_threshold) - threshold
		if points_in_range > 0:
			result += points_in_range * add_per_level
	return result
