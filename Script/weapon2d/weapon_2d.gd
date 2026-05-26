extends Area2D
class_name Weapon2D

const IndexZ = 3
enum WeaponType{BroadSword,ShortSword,SpearT}

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var damage: int = 10
@export var cooldown: float = 0.5
@export var weapon_type:WeaponType
@export var default_direction:bool = true

var can_attack: bool = true
var is_attacking: bool = false
var has_hit: bool = false
var damaged_enemies: Array[Node2D] = []

func _ready() -> void:
	z_index = IndexZ
	visible = false
	body_entered.connect(_on_body_entered)
	var count:int = 0
	while 1:
		await get_tree().create_timer(1.0).timeout
		change_angle(15*count)
		count  += 1
func attack(glo_pos:Vector2):
	pass
func change_angle(angle:float): ##输入angle为角度如60->>60°等
	rotation = deg_to_rad(angle)
	change_angle_sprite(angle)
func change_angle_sprite(angle:float): ##输入angle为角度如60->>60°等
	angle = wrapf(angle, -90.0, 270.0)
	if attack_diretion(angle):
		sprite_2d.flip_h = false
		sprite_2d.rotation = deg_to_rad(45)
	else:
		sprite_2d.flip_h = true
		sprite_2d.rotation = deg_to_rad(135)
func attack_diretion(angle:float)->bool: ##return true==right
	if angle >=-90 and angle <= 90:
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
