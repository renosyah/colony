extends PanelContainer

signal on_exit_button_press()

onready var _title_label = $VBoxContainer/HBoxContainer2/MarginContainer/PanelContainer/Label
onready var _image_ilustration = $VBoxContainer/HBoxContainer2/MarginContainer/HBoxContainer/TextureRect

onready var _player_name_label = $VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/Label
onready var _player_list_squad_container = $VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/GridContainer

onready var _bot_name_label = $VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/Label2
onready var _bot_list_squad_container = $VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/GridContainer

onready var _button_exit = $VBoxContainer/Button

var _battle_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_battle_data(text_result, battle_data, _image_ilustration_sprite):
	if battle_data.empty():
		return
	
	_image_ilustration.texture = load(_image_ilustration_sprite)
	_title_label.text = text_result
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
