extends Control

const MAX_SQUAD = 8

onready var battle_data_instance = BattleData.new()
onready var rng = RandomNumberGenerator.new()

onready var _map_panel = $VBoxContainer/HBoxContainer2/MarginContainer
onready var _map_label = $VBoxContainer/HBoxContainer2/MarginContainer/PanelContainer/map_label
onready var _map_image = $VBoxContainer/HBoxContainer2/MarginContainer/HBoxContainer/map_image

onready var _change_bot_button = $VBoxContainer/HBoxContainer2/MarginContainer/change_bot

onready var _player_label = $VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/player_label
onready var _player_squad_panel = $VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/ScrollContainer/GridContainer

onready var _bot_label = $VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/bot_label
onready var _bot_squad_panel = $VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/ScrollContainer2/GridContainer

onready var _squad_list = $VBoxContainer/HBoxContainer2/squad_list

var _biom_pos = 1
var _bioms  = Biom.BIOMS

var _bot_pos = 1
var _bots  = BotSetting.BOTS

var _battle_data = {
	"type" : BattleData.TYPE_QUICK_BATTLE,
	"name" : "quick battle",
	"bot_setting" :BotSetting.EASY_SETTING,
	"biom" : Biom.GRASS_LAND,
	"battle" : {
		BattleData.PLAYER_SIDE_TAG : {
			"name" : "Player",
			"color" : {
				"r": Color.blue.r,
				"g": Color.blue.g,
				"b": Color.blue.b,
				"a": Color.blue.a
			},
			"squads": [],
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		},
		BattleData.BOT_SIDE_TAG : {
			"name" : "Bot",
			"color" : {
				"r": Color.red.r,
				"g": Color.red.g,
				"b": Color.red.b,
				"a": Color.red.a
			},
			"squads": [],
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		}
	},
	"post_battle" : {
		BattleData.PLAYER_SIDE_TAG : {
			"name" : "",
			"color" : {},
			"squads": [],
			"troop_remain" : 0,
			"troop_kill" : 0,
			"troop_lost" : 0,
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		},
		BattleData.BOT_SIDE_TAG : {
			"name" : "",
			"color" : {},
			"squads": [],
			"troop_remain" : 0,
			"troop_kill" : 0,
			"troop_lost" : 0,
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		}
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_back_pressed():
	get_tree().change_scene("res://asset/scene/menu/menu.tscn")

func _on_add_squad_player_pressed():
	_on_squad_list_on_panel_close()
	_squad_list.connect("on_squad_choosed",self,"_on_squad_choosed_for_player")
	_squad_list.show_squad_list("Player Squad")
	_map_panel.visible = false

func _on_add_squad_bot_pressed():
	_on_squad_list_on_panel_close()
	_squad_list.connect("on_squad_choosed",self,"_on_squad_choosed_for_bot")
	_squad_list.show_squad_list("Bot Squad")
	_map_panel.visible = false

func _on_squad_choosed_for_player(squad):
	if _battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads.size() < MAX_SQUAD:
		squad.side = BattleData.PLAYER_SIDE_TAG
		squad.color = _battle_data.battle[BattleData.PLAYER_SIDE_TAG].color
		_battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads.append(squad)
		
	_player_label.text = "Player ("+ str(_battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads.size()) + "/" +  str(MAX_SQUAD) + ")"
	
	for child in _player_squad_panel.get_children():
		_player_squad_panel.remove_child(child)
		
	for squad in _battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads:
		var squad_menu_item = preload("res://asset/scene/menu/squad_panel_item_menu/squad_panel_item_menu.tscn").instance()
		squad_menu_item.data = squad
		_player_squad_panel.add_child(squad_menu_item)



func _on_squad_choosed_for_bot(squad):
	
	if _battle_data.battle[BattleData.BOT_SIDE_TAG].squads.size() < MAX_SQUAD:
		squad.side = BattleData.BOT_SIDE_TAG
		squad.color = _battle_data.battle[BattleData.BOT_SIDE_TAG].color
		_battle_data.battle[BattleData.BOT_SIDE_TAG].squads.append(squad)
		
	_bot_label.text = "Bot ("+ str(_battle_data.battle[BattleData.BOT_SIDE_TAG].squads.size()) + "/" +  str(MAX_SQUAD) + ")"
	
	for child in _bot_squad_panel.get_children():
		_bot_squad_panel.remove_child(child)
	
	for squad in _battle_data.battle[BattleData.BOT_SIDE_TAG].squads:
		var squad_menu_item = preload("res://asset/scene/menu/squad_panel_item_menu/squad_panel_item_menu.tscn").instance()
		squad_menu_item.data = squad
		_bot_squad_panel.add_child(squad_menu_item)
		
	
	
	
func _on_clear_squad_bot_pressed():
	_battle_data.battle[BattleData.BOT_SIDE_TAG].squads.clear()
	
	for child in _bot_squad_panel.get_children():
		_bot_squad_panel.remove_child(child)


func _on_clear_squad_player_pressed():
	_battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads.clear()
	
	for child in _player_squad_panel.get_children():
		_player_squad_panel.remove_child(child)
	
	
	
func _on_squad_list_on_panel_close():
	for _signal in _squad_list.get_signal_connection_list("on_squad_choosed"):
		_squad_list.disconnect("on_squad_choosed",self,_signal.method)
	_map_panel.visible = true
	
	
func _on_change_map_pressed():
	var biom = _bioms[_biom_pos]
	_battle_data.biom = biom.id
	_map_label.text = biom.name
	_map_image.texture = load(biom.sprite)
	_biom_pos += 1
	if _biom_pos >= _bioms.size():
		_biom_pos = 0
		
func _on_change_bot_setting_pressed():
	var bot = _bots[_bot_pos]
	_battle_data.bot_setting = bot.setting.duplicate()
	_change_bot_button.text = bot.name
	_bot_pos += 1
	if _bot_pos >= _bots.size():
		_bot_pos= 0



func _on_start_battle_pressed():
	if _battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads.empty():
		return
	if _battle_data.battle[BattleData.BOT_SIDE_TAG].squads.empty():
		return
		
	battle_data_instance.battle_data = _battle_data
	battle_data_instance.save_battle()
	
	get_tree().change_scene("res://asset/scene/game/game.tscn")

