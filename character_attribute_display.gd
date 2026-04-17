extends PanelContainer

@onready var label_name: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Label_name
@onready var button_change: Button = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ButtonChange
@onready var label_attribute_vigor: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel
@onready var label_attribute_mind: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel2
@onready var label_attribute_endurance: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel3
@onready var label_attribute_strength: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel4
@onready var label_attribute_dexterity: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel5
@onready var label_attribute_intelligence: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel6
@onready var label_attributelVBox: VBoxContainer = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer
@onready var rich_text_label: RichTextLabel = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/RichTextLabel

var is_display_attribute:bool = true

func update(current_player:Player):
	update_label_attribute(current_player)
	update_label_rich(current_player)
func update_label_attribute(current_player:Player):
	label_name.text = current_player.charater_name
	label_attribute_vigor.update(current_player.get_attribute_rating(current_player.rating_value_vigor),current_player.rating_value_vigor,current_player.attribute_vigor)
	label_attribute_mind.update(current_player.get_attribute_rating(current_player.rating_value_mind),current_player.rating_value_mind,current_player.attribute_mind)
	label_attribute_endurance.update(current_player.get_attribute_rating(current_player.rating_value_endurance),current_player.rating_value_endurance,current_player.attribute_endurance)
	label_attribute_strength.update(current_player.get_attribute_rating(current_player.rating_value_strength),current_player.rating_value_strength,current_player.attribute_strength)
	label_attribute_dexterity.update(current_player.get_attribute_rating(current_player.rating_value_dexterity),current_player.rating_value_dexterity,current_player.attribute_dexterity)
	label_attribute_intelligence.update(current_player.get_attribute_rating(current_player.rating_value_intelligence),current_player.rating_value_intelligence,current_player.attribute_intelligence)
# 调用：update_label_rich($Player)
func update_label_rich(current_player: Player):
	rich_text_label.clear()
	rich_text_label.append_text("[center][b][color=gold]==== 角色状态面板 ====[/color][/b][/center]\n\n")
	# 基础信息
	rich_text_label.append_text("[color=white]等级：[/color][color=yellow]%d[/color]\n" % current_player.charater_level)
	rich_text_label.append_text("[color=white]移速：[/color][color=cyan]%.1f[/color]\n" % current_player.speed)
	rich_text_label.append_text("[color=white]飞行：[/color][color=cyan]%s[/color]  飞行高度：%.1f\n" % [str(current_player.is_fly), current_player.fly_higth])
	rich_text_label.append_text("\n")
	# 生命 & 魔力
	rich_text_label.append_text("[color=red]生命：[/color]%.1f / %.1f\n" % [current_player.health.x, current_player.health.y])
	rich_text_label.append_text("[color=blue]魔力：[/color]%.1f / %.1f\n" % [current_player.magic.x, current_player.magic.y])
	rich_text_label.append_text("\n")
	# 防御
	rich_text_label.append_text("[color=gray]物理防御：[/color]%.1f\n" % current_player.defense_physical)
	rich_text_label.append_text("[color=purple]魔法防御：[/color]%.1f\n" % current_player.defense_magic)
	rich_text_label.append_text("\n")
	# 抗性（转百分比显示）
	rich_text_label.append_text("[color=green]物理抗性：[/color]%.0f%%\n" % (current_player.percentage_physical_resistance * 100))
	rich_text_label.append_text("[color=green]魔法抗性：[/color]%.0f%%\n" % (current_player.percentage_magic_resistance * 100))
	rich_text_label.append_text("[color=green]全体抗性：[/color]%.0f%%\n" % (current_player.percentage_all_resistance * 100))
	rich_text_label.append_text("\n")
	# 重量 & 战斗
	rich_text_label.append_text("[color=orange]负重：[/color]%.1f\n" % current_player.weight)
	rich_text_label.append_text("[color=white]攻击范围：[/color]%.1f\n" % current_player.attack_range)
	rich_text_label.append_text("[color=white]攻击间隔：[/color]%.2f\n" % current_player.attack_inteval)
	rich_text_label.append_text("[color=white]击退系数：[/color]%.0f\n" % current_player.repeled_value)
	# ====================== 六大属性 ======================
	rich_text_label.append_text("[center][b][color=yellow]==== 六大属性 ====[/color][/b][/center]\n")
	rich_text_label.append_text("[color=red]生命力：[/color]%.1f | 基础生命：%.1f | 当前：%.1f\n" % [
		current_player.attribute_vigor, current_player.vigor_health_base, current_player.current_vigor])
	rich_text_label.append_text("[color=blue]集中力：[/color]%.1f | 基础魔力：%.1f | 当前：%.1f\n" % [
		current_player.attribute_mind, current_player.mind_magic_base, current_player.current_mind])
	rich_text_label.append_text("[color=green]耐力：[/color]%.1f | 基础负重：%.1f | 当前：%.1f\n" % [
		current_player.attribute_endurance, current_player.endurance_equip_load_base, current_player.current_endurance])
	rich_text_label.append_text("[color=orange]力量：[/color]%.1f | 补正：%.1f | 当前：%.1f\n" % [
		current_player.attribute_strength, current_player.strength_scaling_base, current_player.current_strength])
	rich_text_label.append_text("[color=cyan]灵巧：[/color]%.1f | 补正：%.1f | 当前：%.1f\n" % [
		current_player.attribute_dexterity, current_player.dexterity_scaling_base, current_player.current_dexterity])
	rich_text_label.append_text("[color=purple]智力：[/color]%.1f | 补正：%.1f | 当前：%.1f\n" % [
		current_player.attribute_intelligence, current_player.intelligence_scaling_base, current_player.current_intelligence])
	rich_text_label.append_text("\n")
	# ====================== 评级成长值 ======================
	rich_text_label.append_text("[center][b][color=gold]==== 评级成长值 ====[/color][/b][/center]\n")
	rich_text_label.append_text("生命力评级：%.1f\n" % current_player.rating_value_vigor)
	rich_text_label.append_text("集中力评级：%.1f\n" % current_player.rating_value_mind)
	rich_text_label.append_text("耐力评级：%.1f\n" % current_player.rating_value_endurance)
	rich_text_label.append_text("力量评级：%.1f\n" % current_player.rating_value_strength)
	rich_text_label.append_text("灵巧评级：%.1f\n" % current_player.rating_value_dexterity)
	rich_text_label.append_text("智力评级：%.1f\n" % current_player.rating_value_intekkigence)
	rich_text_label.append_text("\n[center][color=gray]========================[/color][/center]")
func change_display():
	if is_display_attribute:
		label_attributelVBox.visible = true
		rich_text_label.visible = false
	else:
		label_attributelVBox.visible = false
		rich_text_label.visible = true
func _on_button_change_pressed():
	is_display_attribute = !is_display_attribute
	change_display()
