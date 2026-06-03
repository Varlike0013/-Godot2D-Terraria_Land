extends Character
class_name Player

const COLLISION_LAYERE_CHARACTER = LAYER_PLAYER
const COLLISION_MASK_CHARACTER =  LAYER_SCENE+LAYER_ENEMY
const COLLISION_LAYERE_AREA = LAYER_SCENE
const COLLISION_MASK_AREA = LAYER_SCENE

@export_group("Equipment")
@export var equip_weapon:Weapon
@export var equip_head:Armor
@export var equip_chest:Armor
@export var equip_legg:Armor
@export var equip_accessory_size:int = 4
@export var equip_accessory:Array[Accessory]
@export var weapon_2d:Weapon2D

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
			move_status = MoveStatus.MOVE
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
func _on_take_effect_weapon()->void:
	if weapon_2d:
		if attack_target is Enemy:
			weapon_2d.attack(attack_target.collision_shape_2d.global_position)
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
	pass
