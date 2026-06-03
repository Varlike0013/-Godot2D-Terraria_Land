extends Item
class_name Tool

var tool_efficiency_pickaxe:float = 30
var tool_efficiency_axe:float = 30
var tool_efficiency_hammer:float = 30
var tool_durability:int = 5

func update_info(tdir:int,pah:Vector3): ##耐久，（pickaxe,axe,hammer）
	tool_durability = tdir
	tool_efficiency_pickaxe = pah.x
	tool_efficiency_axe = pah.y
	tool_efficiency_hammer = pah.z
func get_tool_efficiency()->Vector3:
	return Vector3(tool_efficiency_pickaxe,tool_efficiency_axe,tool_efficiency_hammer)
