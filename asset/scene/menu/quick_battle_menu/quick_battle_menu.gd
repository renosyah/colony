extends Control

const MAX_SQUAD = 9

onready var battle_data_instance = BattleData.new()
onready var rng = RandomNumberGenerator.new()

onready var _map_label = $VBoxContainer/HBoxContainer2/MarginContainer/map_label
onready var _map_image = $VBoxContainer/HBoxContainer2/MarginContainer/map_image

onready var _player_label = $VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/player_label
onready var _player_squad_panel = $VBoxContainer/HBoxContainer2/PanelContainer/VBoxContainer/ScrollContainer/GridContainer

onready var _bot_label = $VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/bot_label
onready var _bot_squad_panel = $VBoxContainer/HBoxContainer2/PanelContainer2/VBoxContainer2/ScrollContainer2/GridContainer

onready var _squad_list = $squad_list

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
	_squad_list.disconnect("on_squad_choosed",self,"_on_squad_choosed_for_bot")
	_squad_list.connect("on_squad_choosed",self,"_on_squad_choosed_for_player")
	_squad_list.show()

func _on_add_squad_bot_pressed():
	_squad_list.disconnect("on_squad_choosed",self,"_on_squad_choosed_for_player")
	_squad_list.connect("on_squad_choosed",self,"_on_squad_choosed_for_bot")
	_squad_list.show()



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


func _on_change_map_pressed():
	rng.randomize()
	var biom = Biom.BIOMS[rng.randf_range(0,Biom.BIOMS.size())]
	_battle_data.biom = biom.id
	_map_label.text = biom.name
	_map_image.texture = load(biom.sprite)


func _on_start_battle_pressed():
	if _battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads.empty():
		return
	if _battle_data.battle[BattleData.BOT_SIDE_TAG].squads.empty():
		return
		
	battle_data_instance.battle_data = _battle_data
	battle_data_instance.save_battle()
	
	get_tree().change_scene("res://asset/scene/game/game.tscn")
	
	
