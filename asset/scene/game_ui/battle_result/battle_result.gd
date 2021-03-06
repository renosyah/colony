extends Control

signal on_exit_button_press()

onready var _pre_title_label = $PanelContainer2/VBoxContainer/Label2
onready var _pre_image_ilustration = $PanelContainer2/VBoxContainer/TextureRect2

onready var _result_container = $PanelContainer
onready var _title_label = $PanelContainer/VBoxContainer/HBoxContainer2/MarginContainer/PanelContainer/Label
onready var _image_ilustration = $PanelContainer/VBoxContainer/HBoxContainer2/MarginContainer/VBoxContainer/TextureRect
onready var _quote_label = $PanelContainer/VBoxContainer/HBoxContainer2/MarginContainer/VBoxContainer/Label

onready var _player_name_label = $PanelContainer/VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/Label
onready var _player_list_squad_container = $PanelContainer/VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/GridContainer

onready var _bot_name_label = $PanelContainer/VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/Label2
onready var _bot_list_squad_container = $PanelContainer/VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/GridContainer

onready var _button_exit = $PanelContainer/VBoxContainer/Button

onready var rng = RandomNumberGenerator.new()

var _battle_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_battle_data(text_result, battle_data, _image_ilustration_sprite):
	if battle_data.empty():
		return
	
	rng.randomize()
	_image_ilustration.texture = load(_image_ilustration_sprite)
	_pre_image_ilustration.texture = load(_image_ilustration_sprite)
	_title_label.text = text_result
	_pre_title_label.text = text_result
	_quote_label.text = QuoteData.LIST_QUOTE[rng.randf_range(0,QuoteData.LIST_QUOTE.size())]
	_battle_data = battle_data
	_player_name_label.text = battle_data.battle[BattleData.PLAYER_SIDE_TAG].name
	_bot_name_label.text =  battle_data.battle[BattleData.BOT_SIDE_TAG].name
	_show_remaining_troop()

func _show_remaining_troop():
	for child in _player_list_squad_container.get_children():
		_player_list_squad_container.remove_child(child)
		
	for child in _bot_list_squad_container.get_children():
		_bot_list_squad_container.remove_child(child)
	
	for squad in _battle_data.post_battle[BattleData.PLAYER_SIDE_TAG].squads:
		var squad_menu_item = preload("res://asset/scene/menu/squad_panel_item_menu/squad_panel_item_menu.tscn").instance()
		squad_menu_item.data = squad
		_player_list_squad_container.add_child(squad_menu_item)
		
	for squad in _battle_data.post_battle[BattleData.BOT_SIDE_TAG].squads:
		var squad_menu_item = preload("res://asset/scene/menu/squad_panel_item_menu/squad_panel_item_menu.tscn").instance()
		squad_menu_item.data = squad
		_bot_list_squad_container.add_child(squad_menu_item)
		
func _on_Button_pressed():
	emit_signal("on_exit_button_press")


func _on_Button2_pressed():
	_result_container.visible = true
