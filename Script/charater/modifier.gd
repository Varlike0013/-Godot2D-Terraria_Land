extends RefCounted
class_name Modifier

# 运算类型
enum Operation {
	ADD,       # 加法：value += amount
	PERCENT,   # 百分比：value *= (1 + amount)   (amount = 0.2 表示 +20%)
	MULTIPLY,   # 乘法：value *= amount
	MITIGATION   # 百分比： value = 1-(1-amout)**
}

var source: String          ## 来源描述，如 "装备-铁剑"
var amount: float           ## 数值
var operation: Operation    ## 运算类型

func _init(p_source: String, p_amount: float, p_operation: Operation = Operation.ADD):
	source = p_source
	amount = p_amount
	operation = p_operation
func get_info()->Dictionary:
	return {"source":source,"amount":amount,"operation":operation}
# 静态工厂方法（便于使用）
static func add(source: String, amount: float) -> Modifier: ##_init(operation.add)
	return Modifier.new(source, amount, Operation.ADD)
static func percent(source: String, amount: float) -> Modifier:		##_init(operation.percent)
	return Modifier.new(source, amount, Operation.PERCENT)
static func multiply(source: String, amount: float) -> Modifier:	##_init(operation.multiply)
	return Modifier.new(source, amount, Operation.MULTIPLY)
static func mitigation(source: String, amount: float) -> Modifier:	##_init(operation.mitigation),amout in (0-1)
	return Modifier.new(source, amount, Operation.MITIGATION)
