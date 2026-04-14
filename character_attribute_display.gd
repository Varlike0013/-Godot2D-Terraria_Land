extends PanelContainer

@onready var label_name: Label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Label_name
@onready var button_change: Button = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ButtonChange
@onready var attribute_label: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel
@onready var attribute_label_2: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel2
@onready var attribute_label_3: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel3
@onready var attribute_label_4: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel4
@onready var attribute_label_5: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel5
@onready var attribute_label_6: LabelAttribute = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/AttributeLabel6
@onready var rich_text_label: RichTextLabel = $HBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/PanelContainer/RichTextLabel


func update(current_player:Player):
    current_player.
