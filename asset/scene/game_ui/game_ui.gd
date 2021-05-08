extends Node2D

onready var _formation = preload("res://asset/military/formation/formation.gd").new()
onready var _waypoint = $waypoint

onready var _squad_panel = $CanvasLayer/HBoxContainer3/HBoxContainer2/HBoxContainer

onready var _dialog_result = $CanvasLayer/battle_result

onready var _audio = $AudioStreamPlayer2D

onready var _armies_bar = {
	BattleData.PLAYER_SIDE_TAG : {
		"label" : $CanvasLayer/HBoxContainer/MarginContainer/Label,
		"bar" : $CanvasLayer/HBoxContainer/MarginContainer/left_bar
	},
	BattleData.BOT_SIDE_TAG : {
		"label" : $CanvasLayer/HBoxContainer/MarginContainer2/Label2,
		"bar" :$CanvasLayer/HBoxContainer/MarginContainer2/right_bar
	}
}


var _all_squad = []

var _battle_data = {}
var _squad_in_command = []
var _selected_squad = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_game_battle_data_update(battle_data):
	_battle_data = battle_data
	
func _on_game_army_ready(side, color, total_troop):
	_armies_bar[side].label.text = str(total_troop)
	_armies_bar[side].bar.max_value = total_troop
	_armies_bar[side].bar.value = total_troop
	_armies_bar[side].bar.self_modulate = color

func _on_game_army_update(side, total_troop_left):
	_armies_bar[side].bar.value = max(0, total_troop_left)
	_armies_bar[side].label.text = str(total_troop_left)
	
	if _dialog_result.visible:
		return
	
	# battle result
	if _armies_bar[BattleData.PLAYER_SIDE_TAG].bar.value > 0  and _armies_bar[BattleData.BOT_SIDE_TAG].bar.value <= 0:
		_battle_data.winner = BattleData.PLAYER_SIDE_TAG
		_dialog_result.set_battle_data("You win", _battle_data,"res://asset/ui/ilustration/win.png")
		_dialog_result.visible = true
	elif _armies_bar[BattleData.PLAYER_SIDE_TAG].bar.value <= 0  and _armies_bar[BattleData.BOT_SIDE_TAG].bar.value > 0:
		_battle_data.winner = BattleData.BOT_SIDE_TAG
		_dialog_result.set_battle_data("You Lose", _battle_data,"res://asset/ui/ilustration/loss.png")
		_dialog_result.visible = true

func _on_bot_on_bot_surrender():
	if _dialog_result.visible:
		return
		
	_battle_data.winner = BattleData.PLAYER_SIDE_TAG
	_dialog_result.set_battle_data("You win, Enemy Surrender", _battle_data, "res://asset/ui/ilustration/win.png")
	_dialog_result.visible = true


# button exit
func _on_battle_result_on_exit_button_press():
	if _battle_data.type == BattleData.TYPE_QUICK_BATTLE:
		get_tree().change_scene("res://asset/scene/menu/menu.tscn")
 
func _on_Button_select_all_pressed():
	_audio.stream = preload("res://asset/sound/click.wav")
	_audio.play()
	
	for squad_item in _squad_panel.get_children():
		_selected_squad.append(squad_item.squad)
		squad_item.select_current_squad(true)

func _on_Button_deselect_all_pressed():
	_selected_squad.clear()
	for squad_item in _squad_panel.get_children():
		squad_item.select_current_squad(false)

func _on_Button_fromation_standar_pressed():
	for squad in _selected_squad:
		squad.change_formation(Squad.SQUAD_FORMATION_STANDAR)

func _on_Button_fromation_spread_pressed():
	for squad in _selected_squad:
		squad.change_formation(Squad.SQUAD_FORMATION_SPREAD)

func _on_Button_fromation_compact_pressed():
	for squad in _selected_squad:
		squad.change_formation(Squad.SQUAD_FORMATION_COMPACT)
	
	
# input touch or click
func _on_Control_gui_input(event):
		
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		move_all_selected_squad(get_global_mouse_position())
		
	get_viewport().unhandled_input(event)


func _on_enemy_squad_click(_enemy_squad):
	if _selected_squad.empty():
		return
		
	if !_enemy_squad:
		return
		
	_waypoint.show_waypoint(Color.red,_enemy_squad.get_position())
	
	var formations = _formation.get_formation_box(_enemy_squad.get_position(),_selected_squad.size(),100)
	var idx = 0
	for squad in _selected_squad:
		squad.move_squad_to(formations[idx].position)
		squad.move_and_attack_to(_enemy_squad)
		idx += 1
		
	_audio.stream = preload("res://asset/sound/assault_click.wav")
	_audio.play()
	
	for child in _squad_panel.get_children():
		child.select_current_squad(false)
		
	_selected_squad.clear()

func move_all_selected_squad(pos):
	if _selected_squad.empty():
		return
		
	_waypoint.show_waypoint(Color.white,pos)
		
	var formations = _formation.get_formation_box(pos,_selected_squad.size(),120)
	var idx = 0
	for squad in _selected_squad:
		squad.move_squad_to(formations[idx].position)
		idx += 1
		
#	for child in _squad_panel.get_children():
#		child.select_current_squad(false)
#
#	_selected_squad.clear()
	
	
func _on_all_squad_on_squad_ready(squad):
	_all_squad.append(squad)
	
func _on_squad_on_squad_ready(squad):
	_squad_in_command.append(squad)
	add_squad_to_squad_panel(squad)
	
func _on_squad_on_squad_dead(squad):
	_squad_in_command.erase(squad)
	_selected_squad.erase(squad)
	remove_squad_from_squad_panel(squad)

func add_squad_to_squad_panel(squad):
	var squad_panel_item = preload("res://asset/scene/game_ui/squad_panel_item/squad_panel_item.tscn").instance()
	squad_panel_item.data.name = squad.data.name
	squad_panel_item.data.description = squad.data.description
	squad_panel_item.data.squad_icon = squad.data.squad_icon
	squad_panel_item.data.troop_amount = squad.data.troop_amount
	squad_panel_item.squad = squad
	squad_panel_item.connect("on_squad_icon_click",self,"_on_squad_icon_click")
	_squad_panel.add_child(squad_panel_item)
	
func remove_squad_from_squad_panel(squad):
	for child in _squad_panel.get_children():
		if child.squad == squad:
			_squad_panel.remove_child(child)
		
func _on_squad_icon_click(squad):
	if _selected_squad.has(squad):
		_selected_squad.erase(squad)
	else:
		_selected_squad.append(squad)

func _on_Camera2D_on_camera_moving(_pos, _zoom):
	if _all_squad.empty():
		return
	
	var _squad_banner_transparacy = (_zoom.x - 0.5) # 1.0 => 0.5
	var _squad_banner_scale = _zoom.x
	
	if _squad_banner_transparacy < 0.0:
		_squad_banner_transparacy = 0.0
		
	if _squad_banner_scale < 1.0:
		_squad_banner_scale = 1.0
		
	for squad in _all_squad:
		if is_instance_valid(squad):
			squad.change_banner_visual(_squad_banner_scale, _squad_banner_transparacy)
	
	
	
	

