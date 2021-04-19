extends Node2D

signal army_ready(side,color,total_troop)
signal army_update(side,total_troop_left)
signal battle_data_update(battle_data)

onready var _battle_data_instance = BattleData.new()
onready var _game_ui = $game_ui
onready var _bot = $bot
onready var _tilemap = $terrain

var _battle_data = {}
var _armies = {
	BattleData.BOT_SIDE_TAG : [],
	BattleData.PLAYER_SIDE_TAG : []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_battle_data()
	_tilemap.biom = _battle_data.biom
	_tilemap.generate_battlefield()
	spawn_armies()
	_tilemap.spawn_enviroment()
	
func load_battle_data():
	var _save_file = _battle_data_instance.load_battle()
	if !_save_file:
			get_tree().change_scene("res://asset/scene/menu/menu.tscn")
			
	_battle_data = _save_file
	
func spawn_armies():
	var pos_bot_idx = 0
	for _squad in _battle_data.battle[BattleData.BOT_SIDE_TAG].squads:
		var _pos = _tilemap.top_spawn_position[pos_bot_idx]
		var _color = _battle_data.battle[BattleData.BOT_SIDE_TAG].color
		spawn_enemy_squad(_pos, _squad, _color)
		pos_bot_idx += 1
	
	var pos_player_idx = 0
	for _squad in _battle_data.battle[BattleData.PLAYER_SIDE_TAG].squads:
		var _pos = _tilemap.bottom_spawn_position[pos_player_idx]
		var _color = _battle_data.battle[BattleData.PLAYER_SIDE_TAG].color
		spawn_squad(_pos, _squad,_color)
		pos_player_idx += 1
		
	var data_player = _battle_data.battle[BattleData.PLAYER_SIDE_TAG]
	var data_bot = _battle_data.battle[BattleData.BOT_SIDE_TAG]
	
	emit_signal("army_ready", BattleData.PLAYER_SIDE_TAG ,Color(data_player.color.r,data_player.color.g,data_player.color.b,data_player.color.a), _get_troop_remain(BattleData.PLAYER_SIDE_TAG))
	emit_signal("army_ready",BattleData.BOT_SIDE_TAG,Color(data_bot.color.r,data_bot.color.g,data_bot.color.b,data_bot.color.a), _get_troop_remain(BattleData.BOT_SIDE_TAG))
	
	_bot.set_bot_setting(_battle_data.bot_setting)
	_bot.set_armies(_armies[BattleData.BOT_SIDE_TAG],_armies [BattleData.PLAYER_SIDE_TAG])


func spawn_squad(pos, squad_data, color):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_ready",_game_ui,"_on_all_squad_on_squad_ready")
	squad.connect("on_squad_ready",_game_ui,"_on_squad_on_squad_ready")
	squad.connect("on_squad_dead",_game_ui,"_on_squad_on_squad_dead")
	squad.connect("on_squad_dead",self,"_on_squad_on_squad_dead")
	squad.connect("on_squad_troop_dead",self,"_on_squad_troop_dead")
	squad.data = squad_data.duplicate(true)
	squad.data.color = color
	add_child(squad)
	
	_armies[squad_data.side].append(squad)
	
func spawn_enemy_squad(pos, squad_data, color):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_ready",_game_ui,"_on_all_squad_on_squad_ready")
	squad.connect("on_squad_troop_dead",self,"_on_squad_troop_dead")
	squad.connect("on_squad_dead",self,"_on_squad_on_squad_dead")
	squad.data = squad_data.duplicate(true)
	squad.data.color = color
	add_child(squad)

	_armies[squad_data.side].append(squad)
	
func _on_squad_on_squad_dead(side,squad):
	emit_signal("army_update",side, _get_troop_remain(side))

func _on_squad_troop_dead(side, troop_left):
	emit_signal("army_update",side, _get_troop_remain(side))

func _get_troop_remain(side):
	var troop_sum = 0
	for squad in _armies[side]:
		if is_instance_valid(squad):
			troop_sum += squad.get_troop_left()
	return troop_sum

func _on_timer_update_battle_status_timeout():
	_copy_to_post_battle()
	emit_signal("army_update",BattleData.PLAYER_SIDE_TAG, _get_troop_remain(BattleData.PLAYER_SIDE_TAG))
	emit_signal("army_update",BattleData.BOT_SIDE_TAG, _get_troop_remain(BattleData.BOT_SIDE_TAG))
	emit_signal("battle_data_update", _battle_data)

func _copy_to_post_battle():
	_battle_data.post_battle[BattleData.PLAYER_SIDE_TAG].name = _battle_data.battle[BattleData.PLAYER_SIDE_TAG].name
	_battle_data.post_battle[BattleData.PLAYER_SIDE_TAG].color = _battle_data.battle[BattleData.PLAYER_SIDE_TAG].color.duplicate()
	_battle_data.post_battle[BattleData.PLAYER_SIDE_TAG].position = _battle_data.battle[BattleData.PLAYER_SIDE_TAG].position.duplicate()
	
	_battle_data.post_battle[BattleData.BOT_SIDE_TAG].name = _battle_data.battle[BattleData.BOT_SIDE_TAG].name
	_battle_data.post_battle[BattleData.BOT_SIDE_TAG].color = _battle_data.battle[BattleData.BOT_SIDE_TAG].color.duplicate()
	_battle_data.post_battle[BattleData.BOT_SIDE_TAG].position = _battle_data.battle[BattleData.BOT_SIDE_TAG].position.duplicate()

	_battle_data.post_battle[BattleData.PLAYER_SIDE_TAG].squads.clear()
	_battle_data.post_battle[BattleData.BOT_SIDE_TAG].squads.clear()
	
	for army in _armies[BattleData.PLAYER_SIDE_TAG]:
		if is_instance_valid(army):
			_battle_data.post_battle[BattleData.PLAYER_SIDE_TAG].squads.append(army.data.duplicate(true))
	
	for army in _armies[BattleData.BOT_SIDE_TAG]:
		if is_instance_valid(army):
			_battle_data.post_battle[BattleData.BOT_SIDE_TAG].squads.append(army.data.duplicate(true))

