extends Character
class_name Player

const COLLISION_LAYERE_CHARACTER = LAYER_PLAYER
const COLLISION_MASK_CHARACTER =  LAYER_SCENE+LAYER_ENEMY
const COLLISION_LAYERE_AREA = LAYER_SCENE
const COLLISION_MASK_AREA = LAYER_SCENE

@export_group("Attributes")##vigor mind endurance strength dexterity intelligence
@export var attribute_vigor:float = 10 			##生命力
@export var vigor_health_base:float = 100
@export var vigor_health_growth:Array[Vector2] = [Vector2(1,10),Vector2(30,15),Vector2(50,12),Vector2(80,8),Vector2(100,4)]
@export var attribute_mind:float = 10  			##集中力
@export var mind_magic_base:float = 50
@export var mind_magic_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_strength:float = 10		##力量
@export var strength_scaling_base:float = 50
@export var strength_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_dexterity:float = 10  	##灵巧
@export var dexterity_scaling_base:float = 50
@export var dexterity_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export var attribute_intelligence:float = 10 	##智力
@export var intelligence_scaling_base:float = 50
@export var intelligence_scaling_growth:Array[Vector2] = [Vector2(1,5),Vector2(30,8),Vector2(50,6),Vector2(80,4),Vector2(100,3)]
@export_group("RantingValue") ##影响属性成长
@export var rating_value_vigor:float = 10
@export var rating_value_mind:float = 10
@export var rating_value_endurance:float = 10
@export var rating_value_strength:float = 10
@export var rating_value_dexterity:float = 10
@export var rating_value_intelligence:float = 10
@export_group("Equipment")
@export var equip_weapon:Weapon
@export var equip_head:Armor
@export var equip_chest:Armor
@export var equip_legg:Armor
@export var equip_accessory_size:int = 4
@export var equip_accessory:Array[Accessory]
@export var weapon_2d:Weapon2D

var current_vigor:float
var current_mind:float
var current_strength:float
var current_dexterity:float
var current_intelligence:float
var bonus_strength:float
var bonus_dexterity:float
var bonus_intelligence:float
var enemys:Array[Enemy] = []

func _ready() -> void:
	super._ready()
	collision_layer = COLLISION_LAYERE_CHARACTER
	collision_mask = COLLISION_MASK_CHARACTER
	area_2d_attack.collision_layer = COLLISION_LAYERE_AREA
	area_2d_attack.collision_mask = COLLISION_MASK_AREA
func get_nearest_for_player()->Node2D:
	var result:Node2D = null
	if enemys.size()>0:
		result = get_area_enemy()
		if result:
			return result
	if level:
		result = level.get_nearest_enemy(global_position)
		if result:
			return result
	return result
func execute_stand():
	if attack_target:
		if timer_attack.is_stopped():
			timer_attack.start()
	else:
		attack_target = get_area_enemy()
		if !attack_target:
			move_staus = MoveStaus.move
func get_area_enemy()->Enemy:
	for e in enemys:
		if e:
			return e
		else:
			enemys.erase(e)
	return null
func get_equip(type:Item.ItemType,index:int=0)->Item:
	var res:Item
	match type:
		Item.ItemType.WEAPON: res = equip_weapon
		Item.ItemType.HEAD: res = equip_head
		Item.ItemType.CHEST: res = equip_chest
		Item.ItemType.LEGGINGS: res = equip_legg
		Item.ItemType.ACCESSORY: res = equip_accessory.get(index)
	return res
func set_equip(item_id:int,type:Item.ItemType,index:int=0):
	match type:
		Item.ItemType.WEAPON: equip_weapon = ManagerItem.get_remove_item(item_id)
		Item.ItemType.HEAD: equip_head = ManagerItem.get_remove_item(item_id)
		Item.ItemType.CHEST: equip_chest = ManagerItem.get_remove_item(item_id)
		Item.ItemType.LEGGINGS: equip_legg = ManagerItem.get_remove_item(item_id)
		Item.ItemType.ACCESSORY: equip_accessory.set(index,ManagerItem.get_remove_item(item_id))
func remove_qeuip(type:Item.ItemType,index:int=0):
	match type:
		Item.ItemType.WEAPON: ManagerItem.append_item_quality(equip_weapon.item_id);equip_weapon = null;
		Item.ItemType.HEAD: ManagerItem.append_item_quality(equip_head.item_id);equip_head = null
		Item.ItemType.CHEST: ManagerItem.append_item_quality(equip_chest.item_id);equip_chest = null
		Item.ItemType.LEGGINGS: ManagerItem.append_item_quality(equip_legg.item_id);equip_legg = null
		Item.ItemType.ACCESSORY: ManagerItem.append_item_quality(equip_accessory[index].item_id);equip_accessory[index] = null
func find_equip(type:Item.ItemType,index:int=0)->bool:
	if get_equip(type,index):
		return true
	else:
		return false
func get_all_info()->Dictionary: ##list all attribute
	var dic:Dictionary = {
		"attribute_vigor":attribute_vigor,
	}
	dic.merge(super.get_all_info())
	return dic
func _on_take_effect_weapon()->void:
	if weapon_2d:
		print("weapon_2d",weapon_2d)
		#attack_target.take_hit(attack_damage)
		weapon_2d.attack()
func _on_area_2d_attack_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemys.append(body)
func _on_area_2d_attack_body_exited(body: Node2D) -> void:
	if body is Enemy:
		enemys.erase(body)
		if body == attack_target:
			attack_target = null
func _on_timer_attack_timeout() -> void:
	if attack_target:
		if attack_target is Enemy and attack_target in enemys:
			_on_take_effect_weapon()
			##attack_target.take_hit(attack_damage)
func _on_timer_update() ->void:
	super._on_timer_update()
	##计算五维属性当前值
	current_vigor = attribute_vigor
	current_mind = attribute_mind
	current_strength = attribute_strength
	current_dexterity = attribute_dexterity
	current_intelligence = attribute_intelligence
	##更新生命值和蓝量最大值
	set_health_max(ManagerMath.attribute_base_growth(current_vigor,vigor_health_base,vigor_health_growth))
	set_magic_max(ManagerMath.attribute_base_growth(current_mind,mind_magic_base,mind_magic_growth))
	##更新伤害值
	bonus_strength = ManagerMath.attribute_base_growth(attribute_strength,strength_scaling_base,strength_scaling_growth)
	bonus_dexterity = ManagerMath.attribute_base_growth(attribute_dexterity,dexterity_scaling_base,dexterity_scaling_growth)
	bonus_intelligence = ManagerMath.attribute_base_growth(attribute_intelligence,intelligence_scaling_base,intelligence_scaling_growth)
	attack_damage = equip_weapon.get_damage(self)
