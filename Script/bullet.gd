extends Node2D
class_name Bullet

@export var speed:float = 200
@export var damage:float = 15
@onready var area_2d: Area2D = $Area2D

var target:Node2D

func _ready() -> void:
	area_2d.collision_layer = 2
	area_2d.collision_mask = 2
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	area_2d.body_exited.connect(_on_area_2d_body_exited)
func _physics_process(delta: float) -> void:
	if target:
		var direction = (target.position - position).normalized()
		position += direction * speed * delta
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PylonPoint:
		body.reduce_health(damage)
		queue_free()
func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
