extends Node2D
class_name Block

enum BLOCK_POS_X {MID,LEFT,RIGHT}
enum BLOCK_POS_Y {MID,TOP,BOT}

@export var block_size:Vector2 = Vector2(24,24)
@export var block_pos_x:BLOCK_POS_X = BLOCK_POS_X.MID
@export var block_pos_y:BLOCK_POS_Y = BLOCK_POS_Y.MID
@export var block_texture2D:Texture2D
@export var block_texture2D_size:Vector2 = Vector2(48,48)

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	load_match_texture()
func load_match_texture():
	var image: Image = block_texture2D.get_image()
	var cropped_image: Image = Image.new()
	var new_rect:Vector2 = Vector2.ZERO
	if block_pos_x == BLOCK_POS_X.MID:
		new_rect.x = 12
	elif block_pos_x == BLOCK_POS_X.LEFT:
		new_rect.x = 0
	elif block_pos_x == BLOCK_POS_X.RIGHT:
		new_rect.x = 24
	if block_pos_y == BLOCK_POS_Y.MID:
		new_rect.y = 12
	elif block_pos_y == BLOCK_POS_Y.TOP:
		new_rect.y = 0
	elif block_pos_y == BLOCK_POS_Y.BOT:
		new_rect.y = 24
	cropped_image= image.get_region(Rect2(new_rect,block_size))
	var new_texture: ImageTexture = ImageTexture.create_from_image(cropped_image)
	sprite_2d.texture = new_texture
