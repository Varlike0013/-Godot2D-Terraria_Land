extends PanelContainer
class_name MessageDialog
enum MessageType {NOMAL,CMD,WARNING,ERROR,TIP}

@onready var margin_container: MarginContainer = $MarginContainer
@onready var button_open: Button = $ButtonOpen
@export var button_scale:Vector2 = Vector2(0.2,0.15)
@onready var line_edit: LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/PanelContainer/RichTextLabel

var commands = {
	"help": {"desc": "显示帮助信息","func": _cmd_help},
	"clear": {"desc": "清空聊天记录","func": _cmd_clear},
	"item": {"desc": "物品操作\\item [append/remove/has] [ItemID] [ItemQuality]","func": _cmd_item},
}

func _ready() -> void:
	margin_container.visible = true
	button_open.visible = false
func append_message(text:String,type:MessageType=MessageType.NOMAL):
	match  type:
		MessageType.NOMAL:rich_text_label.append_text(text)
		MessageType.CMD:rich_text_label.append_text("[color=DARK_ORANGE]【指令】"+ text+"[/color] ")
		MessageType.WARNING:rich_text_label.append_text("[color=yellow]【警告】"+ text+"[/color] ")
		MessageType.ERROR:rich_text_label.append_text("[color=ORANGE_RED]【错误】"+ text+"[/color] ")
		MessageType.TIP:rich_text_label.append_text("[color=AQUAMARINE]【提示】"+ text+"[/color] ")
	rich_text_label.append_text("\n")
func change_dialog(is_open:bool):
	if is_open:
		var tween:Tween = create_tween()
		tween.tween_property(self,"modulate:a",0,1.0)
		await tween.finished
		margin_container.visible = true
		button_open.visible = false
		tween = create_tween()
		tween.set_parallel(true)  # 并行模式
		tween.tween_property(self, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(self, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	else:
		var tween:Tween = create_tween()
		tween.set_parallel(true)  # 并行模式
		tween.tween_property(self, "scale", button_scale, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(self, "modulate:a",0, 0.5).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		margin_container.visible = false
		button_open.visible = true
		tween = create_tween()
		tween.tween_property(self,"modulate:a",1,0.5)
func execute_command(input:String):
	var cmd_str = input.substr(1)# 移除开头的 \
	var parts = cmd_str.split(" ", false)  # false 表示不保留空字符串# 分割命令和参数
	var cmd_name = parts[0].to_lower()
	var args = parts.slice(1)  # 获取参数列表
	if commands.has(cmd_name):
		var cmd_func = commands[cmd_name]["func"]
		cmd_func.call(args)
	else:
		append_message("未知命令: " + cmd_name + "，输入 \\help 查看帮助",MessageType.ERROR)
func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.clear()
	if new_text.begins_with("\\"):
		append_message(new_text,MessageType.CMD)
		execute_command(new_text)
	else:
		append_message(new_text)
func _on_button_exit_button_down() -> void:
	change_dialog(false)
func _on_button_open_button_down() -> void:
	change_dialog(true)
func _cmd_help(args:Array):
	append_message("======== 命令列表 ========",MessageType.TIP)
	for cmd_name in commands:
		var desc = commands[cmd_name]["desc"]
		append_message("\\" + cmd_name + " - " + desc,MessageType.TIP)
	append_message("==========================",MessageType.TIP)
func _cmd_clear(args:Array):
	rich_text_label.clear()
func _cmd_item(args:Array):
	if args.is_empty():
		append_message("用法: \\item [append/remove/has] [ItemID] [ItemQuality]",MessageType.ERROR)
		return
	var operation = args[0].to_lower()
	match operation:
		"append", "add", "a":
			if args.size() < 2:
				append_message("请指定物品ID", MessageType.ERROR)
				return
			var item_id:int = int(args[1])
			var item_quality:int = 1
			if args.size() >= 3:
				item_quality = int(args[2])
			append_message("添加物品"+str(item_id)+" "+str(item_quality)+"个", MessageType.TIP)
		"remove", "rm", "r", "delete", "del":
			if args.size() < 2:
				append_message("请指定物品ID", MessageType.ERROR)
				return
			var item_id:int = int(args[1])
			var item_quality:int = 1
			if args.size() >= 3:
				item_quality = int(args[2])
			append_message("移除物品"+str(item_id)+" "+str(item_quality)+"个", MessageType.TIP)
		"has", "check", "c":
			if args.size() < 2:
				append_message("请指定物品ID", MessageType.ERROR)
				return
			var item_id:int = int(args[1])
			var item_quality:int = 1
			if args.size() >= 3:
				item_quality = int(args[2])
			append_message("查找物品"+str(item_id)+" "+str(item_quality)+"个", MessageType.TIP)
