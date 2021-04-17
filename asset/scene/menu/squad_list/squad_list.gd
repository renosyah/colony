extends Control

signal on_squad_choosed(squad)
signal on_panel_close()

onready var _panel_squad_item_list = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer
onready var _label_title = $PanelContainer/VBoxContainer/Panel/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass

func _show_squad_list():
	for squad in SquadData.SQUAD_LIST:
		var squad_menu_item = preload("res://asset/scene/menu/squad_panel_item_menu/squad_panel_item_menu.tscn").instance()
		squad_menu_item.connect("on_squad_icon_click",self,"_on_squad_icon_click")
		squad_menu_item.data = squad
		_panel_squad_item_list.add_child(squad_menu_item)
	
func show_squad_list(title):
	_reset_list()
	_show_squad_list()
	visible = true
	_label_title.text = title

func _reset_list():
	for child in _panel_squad_item_list.get_children():
		_panel_squad_item_list.remove_child(child)

func _on_ok_pressed():
	visible = false
	emit_signal("on_panel_close")

func _on_squad_icon_click(squad):
	emit_signal("on_squad_choosed",squad.duplicate(true))
	
