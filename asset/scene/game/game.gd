extends Node2D

signal army_ready(side,color,total_troop)

onready var game_ui = $game_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	var my_pos = [
		Vector2(-100, 50.0),
		Vector2(100, 50.0),
		Vector2(300, 50.0),
		Vector2(500, 50.0),
		Vector2(700, 50.0),
		Vector2(900, 50.0),
		Vector2(1100, 50.0)
	]
	var enemy_pos = [
		Vector2(-100, 600.0),
		Vector2(100, 600.0),
		Vector2(300, 600.0),
		Vector2(500, 600.0),
		Vector2(700, 600.0),
		Vector2(900, 600.0),
		Vector2(1100, 600.0)
	]
	var squad_types = [
		Squad.SQUAD_TYPE_SPEARMAN,
		Squad.SQUAD_TYPE_SWORDMAN,
		Squad.SQUAD_TYPE_AXEMAN,
		Squad.SQUAD_TYPE_ARCHER,
		Squad.SQUAD_TYPE_CROSSBOWMAN,
		Squad.SQUAD_TYPE_LIGHT_CAVALRY,
		Squad.SQUAD_TYPE_ARCHER_CAVALRY
	]
	
	var post_troop = 0
	for pos in my_pos:
		spawn_squad(pos,squad_types[post_troop])
		post_troop += 1
	emit_signal("army_ready", "red",Color(Color.red),90.0)
		
	var post_troop2 = 0
	for pos in enemy_pos:
		spawn_enemy_squad(pos,squad_types[post_troop2])
		post_troop2 += 1
	emit_signal("army_ready", "blue" ,Color(Color.blue),90.0)

func spawn_squad(pos,squad_type):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_ready",game_ui,"_on_squad_on_squad_ready")
	squad.connect("on_squad_dead",game_ui,"_on_squad_on_squad_dead")
	squad.connect("on_squad_troop_dead",game_ui,"_on_squad_troop_dead")
	squad.data = squad_type.duplicate()
	squad.data.side = "red"
	squad.data.color = Color(Color.red)
	add_child(squad)
	
func spawn_enemy_squad(pos,squad_type):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_troop_dead",game_ui,"_on_squad_troop_dead")
	squad.data = squad_type.duplicate()
	squad.data.side = "blue"
	squad.data.color = Color(Color.blue)
	add_child(squad)
