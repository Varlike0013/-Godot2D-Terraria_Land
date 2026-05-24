extends Area2D
class_name Weapon2D

const IndexZ = 3

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_timer = $HitTimer  # 可选：添加Timer节点防止多次伤害

@export var damage: int = 10
@export var cooldown: float = 0.5

var can_attack: bool = true
var is_attacking: bool = false
var has_hit: bool = false
var damaged_enemies: Array[Node2D] = []

func _ready() -> void:
	z_index = IndexZ
	body_entered.connect(_on_body_entered)
func attack():
	pass
func attack_effect():
	pass
func attack_sword(angle_start:float,angle_end:float,time:float,angle_effect:float=-1):
	pass
func attack_spear(angle:float,distance:float,time:float):
	pass
func _on_body_entered(body:Node2D):
	pass
