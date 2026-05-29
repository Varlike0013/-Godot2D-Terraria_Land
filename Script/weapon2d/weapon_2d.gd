extends Area2D
class_name Weapon2D

const IndexZ = 3
enum WeaponType{BroadSword,ShortSword,SpearT}

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var damage: int = 10
@export var cooldown: float = 0.5
@export var weapon_type:WeaponType
@export var repeled:Vector2 = Vector2(50,-25)
@export var default_direction:bool = true

var can_attack: bool = true
var is_attacking: bool = false
var has_hit: bool = false
var damaged_enemies: Array[Node2D] = []

func _ready() -> void:
	z_index = IndexZ
	finish_attack()
	body_entered.connect(_on_body_entered)
func attack(glo_pos:Vector2):
	var direction:Vector2 = global_position.direction_to(glo_pos)
	var angle_rad: float = direction.angle() ##攻击方向弧度，x轴正方向0，由weapon.position指向target.collision.position
	if weapon_type == WeaponType.BroadSword:
		if attack_diretion(angle_rad):
			attack_sword_broad(deg_to_rad(-120), deg_to_rad(60), 0.3)
		else:
			attack_sword_broad(deg_to_rad(-60), deg_to_rad(-240), 0.3)
	elif weapon_type == WeaponType.ShortSword:
		attack_sword_short(angle_rad,10,0.3)
func start_attack():
	is_attacking = true
	damaged_enemies.clear()
	sprite_2d.visible = true
	collision_shape.disabled = false
func finish_attack():
	is_attacking = false
	sprite_2d.visible = false
	collision_shape.disabled = true
func circle_point(center: Vector2, radius: float, angle_rad: float) -> Vector2:
	return center + Vector2(radius * cos(angle_rad), radius * sin(angle_rad))
func circle_point_deg(center: Vector2, radius: float, angle_deg: float) -> Vector2:
	var rad = deg_to_rad(angle_deg)
	return center + Vector2(radius * cos(rad), radius * sin(rad))
func change_angle(angle_rad:float): ##输入angle_rad为弧度等，rang_area(-2PI,2PI)
	angle_rad = wrapf(angle_rad, -PI*2, 2*PI)
	rotation = angle_rad
	change_angle_sprite(angle_rad)
func change_angle_sprite(angle_rad:float): ##输入angle_rad为弧度等
	if attack_diretion(angle_rad):
		sprite_2d.flip_h = false
		sprite_2d.rotation = deg_to_rad(45)
	else:
		sprite_2d.flip_h = true
		sprite_2d.rotation = deg_to_rad(135)
func attack_diretion(angle_rad:float)->bool: ##return true==right
	if angle_rad >= -PI/2 and angle_rad <= PI/2:
		return true
	else:
		return false
func attack_effect():
	pass
func attack_sword_broad(angle_start:float,angle_end:float,time:float,angle_effect:float=-1):
	pass
func attack_sword_short(angle:float,distance:float,time:float):
	pass
func attack_spear(angle:float,distance:float,time:float):
	pass
func _on_body_entered(body:Node2D):
	pass
