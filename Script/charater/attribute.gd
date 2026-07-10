extends Resource
class_name Attribute

enum AddStrategy { KEEP, OVERWRITE, MAX, MIN } ##add方式KEEP保留 OVERWRITE覆盖 MAX取大 MIN取小

@export var base_value: float = 0.0 :
	set(value):
		if not is_equal_approx(base_value, value):
			base_value = value
			recalculate()   # 修改基础值后重算
var modifiers: Array[Modifier] = []
var current_value: float = 0.0

func _init(p_base: float = 0.0):
	base_value = p_base
	recalculate()
func recalculate() -> void:
	var old_value = current_value
	
	var mit_mods = []
	var has_mit = false
	for mod in modifiers:
		if mod.operation == Modifier.Operation.MITIGATION:
			mit_mods.append(mod)
			has_mit = true
	if has_mit:
		var coefficient = 1.0
		for mod in mit_mods:
			coefficient *= (1.0 - mod.amount)
		current_value = 1.0 - coefficient  # 减伤百分比
	else:
		var value = base_value
		# 分类处理各类修改器（加法、百分比、乘法）
		var add_list: Array[Modifier] = []
		var percent_list: Array[Modifier] = []
		var multiply_list: Array[Modifier] = []
		for mod in modifiers:
			match mod.operation:
				Modifier.Operation.ADD:
					add_list.append(mod)
				Modifier.Operation.PERCENT:
					percent_list.append(mod)
				Modifier.Operation.MULTIPLY:
					multiply_list.append(mod)
		# 应用加法
		for mod in add_list:
			value += mod.amount
		# 应用百分比（累加）
		var percent_total = 0.0
		for mod in percent_list:
			percent_total += mod.amount
		value *= (1.0 + percent_total)
		# 应用乘法
		for mod in multiply_list:
			value *= mod.amount
		current_value = value
	# 如果值发生变化，发射内置 changed 信号
	if not is_equal_approx(current_value, old_value):
		emit_changed()   # 手动触发内置信号，通知所有监听者

# ----- 修改器管理 -----
func add_modifier(mod: Modifier, strategy: AddStrategy = AddStrategy.OVERWRITE) -> void: ##DEFUALT: OVERWRITE覆盖
	var index:int = find_modifiers(mod)
	if index != -1:
		var existing = modifiers[index]
		var should_replace = false
		match strategy:
			AddStrategy.KEEP: return   # 不做任何事，不重算
			AddStrategy.OVERWRITE: should_replace = true
			AddStrategy.MAX: if mod.amount > existing.amount: should_replace = true
			AddStrategy.MIN: if mod.amount < existing.amount: should_replace = true
		if should_replace:
			modifiers[index] = mod
			recalculate()
	else:
		modifiers.append(mod)
		recalculate()
func remove_modifier(source: String) -> void:
	var removed = false
	for i in range(modifiers.size() - 1, -1, -1):
		if modifiers[i].source == source:
			modifiers.remove_at(i)
			removed = true
	if removed:
		recalculate()
func find_modifiers(mod: Modifier) -> int:
	for i in range(modifiers.size()):
		if modifiers[i].source == mod.source and modifiers[i].operation == mod.operation:
			return i
	return -1
func is_exist_modifier(mod: Modifier) -> bool:
	if find_modifiers(mod) != -1:
		return true
	else:
		return false
func clear_modifiers() -> void:
	if modifiers.is_empty():
		return
	modifiers.clear()
	recalculate()

# ----- 基础值直接修改 -----
func set_base(value: float) -> void:
	base_value = value   # 触发 setter，自动重算

func add_base(delta: float) -> void:
	base_value += delta
