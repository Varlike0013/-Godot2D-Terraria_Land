extends Node

enum ProjectilesDic {named,packed}

var projectiles = {
	0:{ProjectilesDic.named:"name",ProjectilesDic.packed:preload("uid://cttmu6hm6v8od")}
}

func get_projectiles_id(input_id:int) ->Bullet:
	var dir:Dictionary = projectiles.get(input_id)
	var packed:PackedScene = dir.get(ProjectilesDic.packed)
	if packed:
		var bullet:Bullet = packed.instantiate()
		return bullet
	return null
