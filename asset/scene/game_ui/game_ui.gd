extends Node2D

onready var _formation = preload("res://asset/military/formation/formation.gd").new()

onready var _squad_panel = $CanvasLayer/HBoxContainer3/HBoxContainer2/HBoxContainer
onready var _squad_detail_panel = $CanvasLayer/squad_panel_detail

onready var _dialog_result = $CanvasLayer/battle_result
onready var _dialog_result_text = $CanvasLayer/battle_result/VBoxContainer/Label

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
	
	# add -1 for more accurate result
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
	_dialog_result.set_battle_data("You win, Enemy Surrender", _battle_data,"res://asset/ui/ilustration/win.png")
	_dialog_result.visible = true


# button exit
func _on_battle_result_on_exit_button_press():
	get_tree().change_scene("res://asset/scene/menu/menu.tscn")
 
func _on_Button_select_all_pressed():
	for squad_item in _squad_panel.get_children():
		_selected_squad.append(squad_item.squad)
		squad_item.select_current_squad(true)

func _on_Button_deselect_all_pressed():
	_squad_detail_panel.visible = false
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
func _on_Control_gui_input( event):
	
	if !_selected_squad.empty() and (event is InputEventScreenTouch or event is InputEventMouseButton) and event.is_pressed():
		move_all_selected_squad(get_global_mouse_position())
		return
		
	get_viewport().unhandled_input(event)

func move_all_selected_squad(pos):
	if !_selected_squad.empty():
		var waypoint = preload("res://asset/ui/waypoint/waypoint.tscn").instance()
		waypoint.position = pos
		add_child(waypoint)
	
	var formations = _formation.get_formation_box(pos,_selected_squad.size(),100)
	var idx = 0
	for squad in _selected_squad:
		squad.move_squad_to(formations[idx].position)
		idx += 1
	
	for child in _squad_panel.get_children():
		child.select_current_squad(false)
		
	_selected_squad.clear()
	_squad_detail_panel.visible = false
	
	
func _on_all_squad_on_squad_ready(squad):
	_all_squad.append(squad)
	
func _on_squad_on_squad_ready(squad):
	_squad_in_command.append(squad)
	add_squad_to_squad_panel(squad)
	
func _on_squad_on_squad_dead(side, squad):
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
	_set_squad_detail(squad)
	if _selected_squad.has(squad):
		_selected_squad.erase(squad)
		_squad_detail_panel.visible = false
	else:
		_selected_squad.append(squad)
		_squad_detail_panel.visible = true

func _set_squad_detail(squad):
	var template = TroopData.MAX_STATS.duplicate()
	template.name = squad.data.name
	template.description = squad.data.description
	template.squad_icon = squad.data.squad_icon
	template.attack_damage = squad.data.troop_data.attack_damage
	template.hit_point = squad.data.troop_data.hit_point
	template.armor = squad.data.troop_data.armor
	template.range_attack = squad.data.troop_data.range_attack
	template.max_speed = squad.data.troop_data.max_speed
	_squad_detail_panel.show_stats(template)


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
	
	
	
	

