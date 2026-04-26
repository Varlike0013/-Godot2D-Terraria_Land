extends RefCounted

enum LogType {Main,Charater,Errors}
var log_dir = "user://logs/"

func _get_date() -> String:
	var time = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [time.year, time.month, time.day]
func _get_log_path(type: String) -> String:
	return log_dir + type + "_" + _get_date() + ".log"
func append_line(msg: String):
	var path = _get_log_path("main")
	write_log(path, "INFO: %s" % msg)
# 写入日志文件
# file_path: 日志路径 例如 "user://game.log"
# content: 要写入的内容
func write_log(path: String, text: String) -> void:
	# 打开文件：不存在则创建，不覆盖
	var file=FileAccess.open(path, FileAccess.READ_WRITE)
	if not file:
		print("无法打开日志文件: ", FileAccess.get_open_error())
	return
	# 游标移到末尾（关键：实现追加）
	file.seek_end()
	# 时间戳 + 内容
	var time_str=Time.get_datetime_string_from_system()
	file.store_line("[%s] %s" % [time_str, text])
	file.flush()  # 立即写入磁盘
	file.close()
