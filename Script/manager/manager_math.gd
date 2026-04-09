extends Node

func resistance_array_to_percentage(array:Array[float]): ##return in range(0,1)
	var result:float = 1
	for ar in array:
		result*(1-ar)
	return result
# 核心函数：根据属性值 + 分段成长表，计算最终数值
# atr: 当前属性点（比如 10 点生命力）
# value_base: 基础值（比如 100 血）
# array_growth: 分段成长数组 [ (阈值, 每级增加量) ]
func attribute_base_growth(atr: int, value_base: float, array_growth: Array[Vector2]) -> float:
    # 先复制基础值
    var result: float = value_base
    # 遍历所有分段成长规则
    for i in range(array_growth.size()):
        # 当前分段的阈值和每级加成
        var threshold: float = array_growth[i].x
        var add_per_level: float = array_growth[i].y
        # 下一个分段的阈值（如果没有就是无穷大）
        var next_threshold: float = INF
        if i < array_growth.size() - 1:
            next_threshold = array_growth[i+1].x
        # 计算当前区间能加多少点
        # 有效点数 =  clamped(属性点, 当前阈值, 下一个阈值) - 当前阈值
        var points_in_range: float = clamp(atr, threshold, next_threshold) - threshold
        if points_in_range > 0:
            result += points_in_range * add_per_level
    return result