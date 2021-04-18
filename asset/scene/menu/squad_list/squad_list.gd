extends Control

signal on_squad_choosed(squad)

onready var _panel_squad_item_list = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer
onready var _label_title = $PanelContainer/VBoxContainer/Panel/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _show_squad_list():
	for squad in SquadData.SQUAD_LIST:
		var squad_menu_item = preload("res://asset/scene/menu/squad_panel_detail_menu/squad_panel_detail_menu.tscn").instance()
		squad_menu_item.connect("on_squad_icon_click",self,"_on_squad_icon_click")
		squad_menu_item.show_stats(squad)
		_panel_squad_item_list.add_child(squad_menu_item)
	
func show_squad_list(title):
	_reset_list()
	_show_squad_list()
	_label_title.text = title

func _reset_list():
	for child in _panel_squad_item_list.get_children():
		_panel_squad_item_list.remove_child(child)

func _on_squad_icon_click(squad):
	emit_signal("on_squad_choosed",squad.duplicate(true))
	
