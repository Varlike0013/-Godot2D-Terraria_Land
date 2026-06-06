extends PanelContainer
class_name BuildingSelectProduction

func update_current(time:float,array_in:Array[Vector2],array_out:Array[Vector2]):
	clear_current()
	label_time.text = str(time)+"sec"
	for ar in array_in:
		append_item_slot(ar,true)
	for ar in array_out:
		append_item_slot(ar,false)
	current_building.update_production(time,array_in,array_out)
func append_item_slot(vec:Vector2,is_input:bool):
	var slot:ProductionItemSlot = PRODUCTION_ITEM_SLOT.instantiate()
	if is_input:
		vbc_item_in.add_child(slot)
	else:
		vbc_item_out.add_child(slot)
	slot.update(vec)
func clear_current():
	for sl in vbc_item_in.get_children():
		sl.queue_free()
	for sl in vbc_item_out.get_children():
		sl.queue_free()
func array_vector2(array_in:Array)->Array[Vector2]:
	var new_arr:Array[Vector2] = []
	for ar in array_in:
		if ar is Vector2:
			new_arr.append(ar)
	return new_arr
func _on_pressed_formula(time:float,array_in:Array[Vector2],array_out:Array[Vector2]):
	update_current(time,array_in,array_out)
