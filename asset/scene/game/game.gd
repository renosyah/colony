extends Node2D

signal army_ready(side,color,total_troop)
signal army_update(side,total_troop_left)

enum {
	GRASS_LAND,
	WET_LAND,
	MUD_LAND,
	URBAN_LAND
}
const TILE_ID = {
	'grass' : 0,
	'mud' : 1,
	'water' : 2,
	'dirt' : 3
}
const HEIGHT = 200
const WIDHT = 200

onready var rng = RandomNumberGenerator.new()
onready var game_ui = $game_ui
onready var bot = $bot
onready var tilemap = $TileMap

var biom = GRASS_LAND
var squad_list = SquadData.SQUAD_LIST
var armies = {
	"red" : [],
	"blue" : []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_battlefield()
	spawn_armies()
	

func generate_battlefield():
	rng.randomize()
	var simplex = OpenSimplexNoise.new()
	simplex.seed = rng.randi()
	
	simplex.octaves = 4
	simplex.period = 15
	simplex.lacunarity = 1.5
	simplex.persistence = 0.75
	
	for x in WIDHT:
		for y in HEIGHT:
			tilemap.set_cellv(Vector2(x - WIDHT / 2,y - HEIGHT / 2),_get_tile_index(biom,simplex.get_noise_2d(float(x),float(y))))
	tilemap.update_bitmask_region()
	
func _get_tile_index(_biom, _noice_sample):
	match _biom:
		GRASS_LAND:
			if _noice_sample < 0.0:
				return TILE_ID.grass
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return TILE_ID.water
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return TILE_ID.mud
		WET_LAND:
			if _noice_sample < 0.0:
				return TILE_ID.water
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return TILE_ID.water
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return TILE_ID.grass
				
		MUD_LAND:
			if _noice_sample < 0.0:
				return TILE_ID.mud
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return TILE_ID.water
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return TILE_ID.grass

		URBAN_LAND:
			if _noice_sample < 0.0:
				return TILE_ID.grass
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return TILE_ID.dirt
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return TILE_ID.dirt
				
	return TILE_ID.grass


func spawn_armies():
	var enemy_pos = [
		Vector2(-100, 50.0),
		Vector2(100, 50.0),
		Vector2(300, 50.0),
		Vector2(500, 50.0),
		Vector2(700, 50.0),
		Vector2(900, 50.0),
		Vector2(1100, 50.0),
		Vector2(1300, 50.0),
		Vector2(1500, 50.0)
	]
	var my_pos = [
		Vector2(-100, 600.0),
		Vector2(100, 600.0),
		Vector2(300, 600.0),
		Vector2(500, 600.0),
		Vector2(700, 600.0),
		Vector2(900, 600.0),
		Vector2(1100, 600.0),
		Vector2(1300, 600.0),
		Vector2(1500, 600.0)
	]
	
	var post_troop2 = 0
	for pos in enemy_pos:
		spawn_enemy_squad(pos,squad_list[post_troop2])
		post_troop2 += 1
		
	var post_troop = 0
	for pos in my_pos:
		spawn_squad(pos,squad_list[post_troop])
		post_troop += 1
		
	emit_signal("army_ready", "blue" ,Color(Color.blue), _get_troop_remain("blue"))
	emit_signal("army_ready","red",Color(Color.red), _get_troop_remain("red"))
	
	bot.set_bot_setting(BotSetting.EASY_SETTING)
	bot.set_armies(armies["red"], armies["blue"])


func spawn_squad(pos,squad_type):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_ready",game_ui,"_on_squad_on_squad_ready")
	squad.connect("on_squad_dead",game_ui,"_on_squad_on_squad_dead")
	squad.connect("on_squad_dead",self,"_on_squad_on_squad_dead")
	squad.connect("on_squad_troop_dead",self,"_on_squad_troop_dead")
	squad.data = squad_type.duplicate()
	squad.data.side = "blue"
	squad.data.color = Color(Color.blue)
	add_child(squad)
	
	armies[squad.data.side].append(squad)
	
func spawn_enemy_squad(pos,squad_type):
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.position = pos
	squad.connect("on_squad_troop_dead",self,"_on_squad_troop_dead")
	squad.connect("on_squad_dead",self,"_on_squad_on_squad_dead")
	squad.data = squad_type.duplicate()
	squad.data.side = "red"
	squad.data.color = Color(Color.red)
	add_child(squad)
	
	armies[squad.data.side].append(squad)
	
func _on_squad_on_squad_dead(side,squad):
	emit_signal("army_update",side, _get_troop_remain(side))

func _on_squad_troop_dead(side, troop_left):
	emit_signal("army_update",side, _get_troop_remain(side))

func _get_troop_remain(side):
	var troop_sum = 0
	for squad in armies[side]:
		if is_instance_valid(squad):
			troop_sum += squad.get_troop_left()
	return troop_sum
