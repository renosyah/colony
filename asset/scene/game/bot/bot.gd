extends Node2D

signal on_bot_surrender()

onready var rng = RandomNumberGenerator.new()
onready var _formation = preload("res://asset/military/formation/formation.gd").new()
onready var _tinker_time = $thinker_time

var _enemy_squad = []

var _squad_in_command = []
var _selected_squad = []

# default data prevent null pointer
var data = {
	"maximum_squad_control" : 1,
	"min_tinker_time" : 10,
	"max_tinker_time" : 50,
	"surrender_chance" : 0.5,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_bot_setting(_data):
	data = _data
	_enemy_squad.clear()
	_squad_in_command.clear()
	_tinker_time.wait_time = rng.randf_range(data.min_tinker_time,data.max_tinker_time)
	_tinker_time.start()
	
func set_armies(_bot_squad,_oponent_squad):
	_squad_in_command = _bot_squad
	_enemy_squad = _oponent_squad

func _set_selected_squad():
	rng.randomize()
	_selected_squad.clear()
	for i in data.maximum_squad_control:
		var squad = _squad_in_command[rng.randf_range(0,_squad_in_command.size())]
		_selected_squad.append(squad)

func _attack_enemy_squad():
	rng.randomize()
	var _squad_targets = []

	if _enemy_squad.empty():
		return

	var enemy_squad = _enemy_squad[rng.randf_range(0,_enemy_squad.size())]
	if is_instance_valid(enemy_squad) and !enemy_squad.is_disbanded:
		_squad_targets.append(enemy_squad)
		
	for target in _squad_targets:
		_set_all_selected_squad_to_attack(target)
	
func _to_fromation_standar():
	for squad in _selected_squad:
		if is_instance_valid(squad):
			if !squad.is_disbanded:
				squad.change_formation(Squad.SQUAD_FORMATION_STANDAR)

func _to_fromation_spread():
	for squad in _selected_squad:
		if is_instance_valid(squad):
			if !squad.is_disbanded:
				squad.change_formation(Squad.SQUAD_FORMATION_SPREAD)

func _to_fromation_compact():
	for squad in _selected_squad:
		if is_instance_valid(squad):
			if !squad.is_disbanded:
				squad.change_formation(Squad.SQUAD_FORMATION_COMPACT)
	

func _set_all_selected_squad_to_attack(_squad_target):
	rng.randomize()
	for squad in _selected_squad:
		if is_instance_valid(squad):
			if rng.randf() < 0.5:
				var _x = squad.get_position().x + rng.randf_range(rng.randf_range(-520,-490), rng.randf_range(320,430))
				var _y = squad.get_position().y + rng.randf_range(rng.randf_range(-520,-490), rng.randf_range(320,430))
				squad.move_squad_to(Vector2(_x,_y))
			else:
				squad.move_squad_to(_squad_target.get_position())
				squad.move_and_attack_to(_squad_target)

func _on_thinker_time_timeout():
	if _squad_in_command.size() <= 0 || _enemy_squad.size() <= 0:
		return
	_set_selected_squad()
	
	rng.randomize()
	var _remnant = _get_total_squad_all_army()
	if rng.randf() < data.surrender_chance and _remnant["bot"].squad_left < _remnant["enemy"].squad_left:
		rng.randomize()
		if rng.randf() < data.surrender_chance and _remnant["bot"].troop_left < _remnant["enemy"].troop_left:
			emit_signal("on_bot_surrender")
			return
	
	rng.randomize()
	var percent = rng.randf()
	if (percent < 0.2):
		_to_fromation_standar()
	elif(percent < 0.3):
		_to_fromation_spread()
	elif(percent < 0.2):
		_to_fromation_compact()
		
	_attack_enemy_squad()
	_tinker_time.wait_time = rng.randf_range(data.min_tinker_time,data.max_tinker_time)
	_tinker_time.start()

func _get_total_squad_all_army():
	var _squad_in_command_count = 2
	var _troop_in_command_count = 8
	
	var _enemy_squad_count = 0
	var _enemy_troop_count = 0
	
	for squad in _squad_in_command:
		if is_instance_valid(squad):
			_troop_in_command_count += squad.get_troop_left()
			_squad_in_command_count += 1
		
	for squad in _enemy_squad:
		if is_instance_valid(squad):
			_enemy_troop_count += squad.get_troop_left()
			_enemy_squad_count += 1
	
	return {
		"bot" : {
			"troop_left" : _troop_in_command_count,
			"squad_left" : _squad_in_command_count
		},
		"enemy" : {
			"troop_left" : _enemy_troop_count,
			"squad_left" : _enemy_squad_count
		}
	}
	
	
func _on_reset_data_timeout():
	if _squad_in_command.size() <= 0 || _enemy_squad.size() <= 0:
		return
		
	for squad in _enemy_squad:
		if !is_instance_valid(squad):
			_enemy_squad.erase(squad)
			break
 
	for squad in _squad_in_command:
		if !is_instance_valid(squad):
			_enemy_squad.erase(squad)
			break

