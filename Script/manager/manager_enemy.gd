extends Node

enum EnemyInfoType{Name,packed,Null}

const EnemyInfo:Dictionary = {
	0:{EnemyInfoType.Name:"史莱姆",EnemyInfoType.packed:preload("uid://cfc72nagr64vc")},
}

func get_enemy(new_id:int):
	var dic:Dictionary = EnemyInfo.get(new_id)
	if dic:
		var packed:PackedScene = dic.get(EnemyInfoType.packed)
		var enemy:Enemy = packed.instantiate()
		return enemy
	return null
