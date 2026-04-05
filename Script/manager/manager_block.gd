extends Node
const BLOCKS = {
	0:preload("uid://p7cia1lnsv3")
}

func get_block_id(id:int)->Block:
	var packed:PackedScene = BLOCKS.get(id)
	if packed:
		var new_block:Block = packed.instantiate()
		return new_block
	else:
		return null
