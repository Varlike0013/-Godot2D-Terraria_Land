extends Item
class_name ItemTool

var tool_efficiency_prickaxe:float = 30
var tool_efficiency_axe:float = 30
var tool_efficiency_hammer:float = 30
var tool_durability:int = 5

func update_tool(pah:Vector3):
	tool_efficiency_prickaxe = pah.x
	tool_efficiency_axe = pah.y
	tool_efficiency_hammer = pah.z
func get_tool_efficiency()->Vector3:
	return Vector3(tool_efficiency_prickaxe,tool_efficiency_axe,tool_efficiency_hammer)
