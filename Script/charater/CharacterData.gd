extends Resource
class_name CharacterData

@export var default_direction: bool = true   ##default_direction == Left && true
@export var group_target: String = "Character"
@export var character_name: String = "name"
@export var is_fly: bool = false
@export var fly_height: float = 50.0
@export_group("BasicAttributes")
@export var speed: Attribute = Attribute.new(100.0)
@export var health: float = 100.0
@export var health_max:Attribute = Attribute.new(100.0)
@export var magic: float = 50.0
@export var magic_max:Attribute = Attribute.new(50.0)
@export var defense: Attribute = Attribute.new(0) 	##固定减伤
@export var bonus: Attribute = Attribute.new(0)		##固定增伤
@export var penetration: Attribute = Attribute.new(0)		##护甲穿透
@export var resistance_pec: Attribute = Attribute.new(0) 	##百分比减伤
@export var bonus_pec: Attribute = Attribute.new(0) ##百分比增伤
@export_group("level")
@export var character_level: int = 1
@export var level_growth_health:float = 10.0
@export var level_growth_magic:float = 5.0
@export var level_growth_bonus:float = 5.0
@export var level_growth_defense:float = 3.0
@export_group("Attack", "attack")
@export var attack_distance: float = 50.0	##攻击距离
@export var attack_damage: float = 5.0		##攻击伤害
@export var attack_range: float = 1.0		##索敌范围
@export var attack_interval: float = 1.0	##攻击间隔
@export_group("Repelled")
@export var repeled_speed: float = 1.0 ##击退常数，决定被击退时的距离

func reduce_health(value:float):
	if value>0:
		health -= value
		health= max(0,health)
func restore_health(value:float):
	if value>0:
		health += value
		health = min(health_max.current_value,health)
func restore_health_percentage(per:float): ##per range in (0,100)
	restore_health(health_max.current_value*(per/100.0))
func reduce_health_percentage(per:float):  ##per range in (0,100)
	reduce_health(health_max.current_value*(per/100.0))
func get_lost_health_percentage() -> float:
	if health_max.current_value == 0:
		return 0.0  # 避免除以零
	return (health_max.current_value - health) / health_max.current_value * 100.0
func set_health_max(value:float): ##set_health_max_base_value
	health_max.set_base(value)
	if health>health_max.current_value:
		health = health_max.current_value
func reduce_magic(value:float):
	magic -= value
	magic = max(0,magic)
func restore_magic(value:float):
	magic += value
	magic = min(magic_max.current_value,magic)
func is_magic_enough(value:float) ->bool:
	if magic>=value:
		return true
	else:
		return false
func set_magic_max(value:float):
	magic_max.set_base(value)
	if magic>magic_max.current_value:
		magic = magic_max.current_value
func update_level_modifier():
	health_max.add_modifier(Modifier.add("level",level_growth_health*(character_level-1)))
	magic_max.add_modifier(Modifier.add("level",level_growth_magic*(character_level-1)))
	defense.add_modifier(Modifier.add("level",level_growth_defense*(character_level-1)))
	bonus.add_modifier(Modifier.add("level",level_growth_bonus*(character_level-1)))
func calculate_taken_damage(damage: float,pent:float) -> float: ##受到伤害计算（由被攻击者调用）：pent护甲穿透
	damage *= 1-resistance_pec.current_value
	var def:float = max(0,(defense.current_value-pent))
	return damage-def
func calculate_dealt_damage(damage: float) -> float: ##造成伤害计算（由攻击者调用）
	return (damage+bonus.current_value)*(1+bonus_pec.current_value)
