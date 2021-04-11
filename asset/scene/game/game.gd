extends Node2D

onready var game_ui = $game_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	var my_pos = [Vector2(300, 200.0),Vector2(450, 200.0),Vector2(600, 200.0)]
	var enemy_pos = [Vector2(300, 400.0),Vector2(450, 400.0),Vector2(600, 400.0)]
	var squad_types = [Squad.SQUAD_TYPE_SPEARMAN,Squad.SQUAD_TYPE_SWORDMAN,Squad.SQUAD_TYPE_AXEMAN]
	
	var post_troop = 0
	for pos in my_pos:
		spawn_squad(pos,squad_types[post_troop])
		post_troop += 1
		
	var post_troop2 = 0
	for pos in enemy_pos:
		spawn_enemy_squad(pos,squad_types[post_troop2])
		post_troop2 += 1
		
	#spawn_resources()
	#spawn_depot()

func spawn_squad(pos,squad_type):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_ready",game_ui,"_on_squad_on_squad_ready")
	squad.connect("on_squad_dead",game_ui,"_on_squad_on_squad_dead")
	squad.data = squad_type.duplicate()
	squad.data.side = "red"
	squad.data.color = Color(Color.red)
	add_child(squad)
	
func spawn_enemy_squad(pos,squad_type):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.data = squad_type.duplicate()
	squad.data.side = "blue"
	squad.data.color = Color(Color.blue)
	add_child(squad)
	
	
func spawn_depot():
	var depot = preload("res://asset/collector/depot/collector_building.tscn").instance()
	depot.position = Vector2(140.0, 300.0)
	depot.connect("resource_collected",game_ui,"_on_resource_collected")
	add_child(depot)
	
func spawn_resources():
	var farm = preload("res://asset/resources/resource.tscn").instance()
	farm.position = Vector2(865.0, 80.0)
	farm.data.type = Resources.RESOURCES_TYPE_FOOD
	farm.data.amount = 50.0
	add_child(farm)
	
	var tree = preload("res://asset/resources/resource.tscn").instance()
	tree.position = Vector2(860.0, 300.0)
	tree.data.type = Resources.RESOURCES_TYPE_WOOD
	tree.data.amount = 50.0
	add_child(tree)
	
	var ore = preload("res://asset/resources/resource.tscn").instance()
	ore.position = Vector2(865.0, 530.0)
	ore.data.type = Resources.RESOURCES_TYPE_MINERAL
	ore.data.amount = 50.0
	add_child(ore)
	