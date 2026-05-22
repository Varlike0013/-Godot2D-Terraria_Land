extends Node2D
class_name Level

const DROP_ITEM_2D = preload("uid://idmr06b3sjgh")

@onready var charaters: Node2D = $Charaters
@onready var enemys: Node2D = $Charaters/Enemys
@onready var projectile: Node2D = $Projectile
@onready var drops: Node2D = $Drops
@onready var level_ui: LevelUi = $LevelUi
@onready var buiding_rows: VBoxContainer = $ControlBuildings/MarginContainer/BuidingRows
@onready var displayer_character_info: DisplayCharacterInfo = $LevelUi/UI_Top/DisplayerCharacterInfo
@onready var node_players: Node2D = $Charaters/Players

@export var pylon_point:PylonPoint
@export var camera2d:Camera2D
@export var level_scene_size:Vector2 = Vector2(1600,1000)
@export var start_building:Array[int]

var start_pos:Vector2 = Vector2(300,300)

func _ready() -> void:
	camera2d.limit_left = 0
	camera2d.limit_top = 0
	camera2d.limit_bottom = 1000
	camera2d.limit_right = 1600
	displayer_character_info.visible = false
	load_start_buildings()
func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event is InputEventMouseButton:
			if event.button_mask == MouseButtonMask.MOUSE_BUTTON_MASK_LEFT and event.is_pressed():
				var result = raycast_check_for_player()
				if result:
					if result is Player:
						displayer_character_info.display(result)
func load_start_buildings():
	await get_tree().create_timer(0.1).timeout
	for sbd in start_building:
		append_building(sbd)
func append_projectile(btl:Bullet):
	projectile.add_child(btl)
func append_enemy(enemy:Enemy,pos:Vector2):
	enemy.level = self
	enemys.add_child(enemy)
	enemy.position = pos
func append_building(id:int):
	var empty_row:BuildingRow = get_empty_building_row()
	if empty_row:
		empty_row.append_building(id)
func append_drops(drop_id:int,pos:Vector2):
	var drop_item:DropItem2D = get_drop_item2d()
	drop_item.position = pos
	drops.add_child(drop_item)
	drop_item.update(drop_id)
	drop_item.be_drop()
func get_drop_item2d()->DropItem2D:
	var dr:DropItem2D = DROP_ITEM_2D.instantiate()
	return dr
func get_building_rows()->Array[BuildingRow]:
	var nodes:Array[Node] = buiding_rows.get_children()
	var new_array:Array[BuildingRow] = []
	for nd in nodes:
		if nd is BuildingRow:
			new_array.append(nd)
	return new_array
func get_empty_building_row()->BuildingRow:
	var new_array:Array[BuildingRow] = get_building_rows()
	for bd in new_array:
		if bd.is_has_empty:
			return bd
	return null
func get_nearest_enemy(pos:Vector2)->Enemy:
	var nearest_dis:float = 99999.0
	var nearest:Enemy
	var enemy_array:Array[Enemy] = get_enemys()
	for en in enemy_array:
		if en is Enemy:
			var current:float = en.position.distance_to(pos)
			if current<nearest_dis:
				nearest_dis = current
				nearest = en
	return nearest
func get_nearest_player(pos:Vector2)->Player:
	var nearest_dis:float = 99999.0
	var nearest:Player
	var array:Array[Player] = get_players()
	for ar in array:
		if ar is Player:
			var current:float = ar.position.distance_to(pos)
			if current<nearest_dis:
				nearest_dis = current
				nearest = ar
	return nearest
func get_players()->Array[Player]:
	var nodes:Array[Player]
	for nd in node_players.get_children():
		if nd is Player:
			nodes.append(nd)
	return nodes
func get_enemys()->Array[Enemy]:
	var nodes:Array[Enemy]
	for nd in enemys.get_children():
		if nd is Enemy:
			nodes.append(nd)
	return nodes
func raycast_check_for_player(): ##会返回player和enemy类
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = Player.COLLISION_LAYERE_PLAYER
	var result = space_state.intersect_point(parameters)
	if result.size()>0:
		return result[0].collider.get_parent()
	else:
		return null
func load_blocks():
	for i in range(10):
		for j in range(10):
			var block_test:Block = ManagerBlock.get_block_id(0)
			block_test.position = start_pos+Vector2(block_test.block_size.x*j,block_test.block_size.y*i)
			if i == 0:
				block_test.block_pos_y = Block.BLOCK_POS_Y.TOP
			elif i == 9:
				block_test.block_pos_y = Block.BLOCK_POS_Y.BOT
			if j == 0:
				block_test.block_pos_x = Block.BLOCK_POS_X.LEFT
			elif j == 9:
				block_test.block_pos_x = Block.BLOCK_POS_X.RIGHT
			add_child(block_test)
func add_item_bag(item:Item):
	level_ui.add_item_bag(item)
