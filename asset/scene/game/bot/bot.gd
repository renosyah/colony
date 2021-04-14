extends Node
class_name Bot

const EASY_SETTING = {
	"maximum_squad_control" : 1,
	"maximum_squad_target" : 5,
	"min_tinker_time" : 10,
	"max_tinker_time" : 20
}
const MEDIUM_SETTING = {
	"maximum_squad_control" : 2,
	"maximum_squad_target" : 2,
	"min_tinker_time" : 10,
	"max_tinker_time" : 30
}
const HARD_SETTING = {
	"maximum_squad_control" : 5,
	"maximum_squad_target" : 1,
	"min_tinker_time" : 5,
	"max_tinker_time" : 10
}

onready var rng = RandomNumberGenerator.new()
onready var _formation = preload("res://asset/military/formation/formation.gd").new()
onready var _tinker_time = $thinker_time

var _enemy_squad = []

var _squad_in_command = []
var _selected_squad = []

var data = {
	"maximum_squad_control" : 1,
	"maximum_squad_target" : 1,
	"min_tinker_time" : 10,
	"max_tinker_time" : 50
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
	var _pos_target = []
	while _pos_target.size() < data.maximum_squad_target:
		var enemy_squad = _enemy_squad[rng.randf_range(0,_enemy_squad.size())]
		var own_squad = _squad_in_command[rng.randf_range(0,_squad_in_command.size())]
		
		if is_instance_valid(enemy_squad):
			var _rand_pos = enemy_squad.global_position
			_rand_pos.x += rng.randf_range(-100,100)
			_rand_pos.y += rng.randf_range(-100,100)
			_pos_target.append(_rand_pos)
			
		elif is_instance_valid(own_squad):
			var _rand_pos = own_squad.global_position
			_rand_pos.x += rng.randf_range(-100,100)
			_rand_pos.y += rng.randf_range(-100,100)
			_pos_target.append(_rand_pos)
			
		else:
			_pos_target.append(Vector2.ZERO)
		
	for target in _pos_target:
		if target != Vector2.ZERO:
			_move_all_selected_squad(target)
	
func _to_fromation_standar():
	for squad in _selected_squad:
		if is_instance_valid(squad):
			squad.change_formation(Squad.SQUAD_FORMATION_STANDAR)

func _to_fromation_spread():
	for squad in _selected_squad:
		if is_instance_valid(squad):
			squad.change_formation(Squad.SQUAD_FORMATION_SPREAD)

func _to_fromation_compact():
	for squad in _selected_squad:
		if is_instance_valid(squad):
			squad.change_formation(Squad.SQUAD_FORMATION_COMPACT)
	

func _move_all_selected_squad(pos):
	var formations = _formation.get_formation_box(pos,_selected_squad.size(),100)
 
	var idx = 0
	for squad in _selected_squad:
		if is_instance_valid(squad):
			squad.move_squad_to(formations[idx].position)
			idx += 1

func _on_thinker_time_timeout():
	if _squad_in_command.size() <= 0 || _enemy_squad.size() <= 0:
		return
	_set_selected_squad()
	
	var percent = rng.randf()
	if (percent > 0.8):
		_to_fromation_standar()
	elif(percent < 0.8 and percent > 0.4):
		_to_fromation_spread()
	else:
		_to_fromation_compact()
		
 
	_attack_enemy_squad()
	_tinker_time.wait_time = rng.randf_range(data.min_tinker_time,data.max_tinker_time)
	_tinker_time.start()


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

