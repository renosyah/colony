extends Navigation2D

onready var rng = RandomNumberGenerator.new()
onready var _tilemap = $TileMap
onready var _audio = $AudioStreamPlayer2D

var biom = Biom.GRASS_LAND
var tile_size = Vector2(100.0,100.0)
	
const top_spawn_position = [
	Vector2(-700, 10.0),
	Vector2(-500, 10.0),
	Vector2(-300, 10.0),
	Vector2(-100, 10.0),
	Vector2(100, 10.0),
	Vector2(300, 10.0),
	Vector2(500, 10.0),
	Vector2(700, 10.0),
	Vector2(900, 10.0),
]
	
const bottom_spawn_position = [
	Vector2(-700, 580.0),
	Vector2(-500, 580.0),
	Vector2(-300, 580.0),
	Vector2(-100, 580.0),
	Vector2(100, 580.0),
	Vector2(300, 580.0),
	Vector2(500, 580.0),
	Vector2(700, 580.0),
	Vector2(900, 580.0),
]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func generate_battlefield():
	rng.randomize()
	var simplex = OpenSimplexNoise.new()
	simplex.seed = rng.randi()
	
	simplex.octaves = 4
	simplex.period = 15
	simplex.lacunarity = 1.5
	simplex.persistence = 0.75
	
	for x in tile_size.x:
		for y in tile_size.y:
			var pos = Vector2(x - tile_size.x / 2,y - tile_size.y / 2)
			_tilemap.set_cellv(pos,_get_tile_index(biom, simplex.get_noise_2d(float(x),float(y))))
			
	for x in [0, tile_size.x - 1]:
		for y in range(tile_size.y):
			_tilemap.set_cellv(Vector2(x - tile_size.x / 2,y - tile_size.y / 2), Biom.TILE_ID.wall)
	for x in range(1, tile_size.x - 1):
		for y in [0, tile_size.y - 1]:
			_tilemap.set_cellv(Vector2(x - tile_size.x / 2,y - tile_size.y / 2), Biom.TILE_ID.wall)
	
	_tilemap.update_bitmask_region()
	
	
func _get_tile_index(_biom, _noice_sample):
 
	if _biom == Biom.GRASS_LAND:
			if _noice_sample < 0.0:
				return Biom.TILE_ID.grass
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return Biom.TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return Biom.TILE_ID.water
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return Biom.TILE_ID.mud
				
	elif _biom == Biom.WET_LAND:
			if _noice_sample < 0.0:
				return Biom.TILE_ID.water
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return Biom.TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return Biom.TILE_ID.water
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return Biom.TILE_ID.grass
				
	elif _biom == Biom.MUD_LAND:
			if _noice_sample < 0.0:
				return Biom.TILE_ID.mud
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return Biom.TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return Biom.TILE_ID.water
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return Biom.TILE_ID.grass

	elif _biom == Biom.URBAN_LAND:
			if _noice_sample < 0.0:
				return Biom.TILE_ID.grass
			elif _noice_sample > 1.0 and _noice_sample < 0.2:
				return Biom.TILE_ID.grass
			elif _noice_sample > 0.2 and _noice_sample < 0.3:
				return Biom.TILE_ID.dirt
			elif _noice_sample > 0.3 and _noice_sample < 0.6:
				return Biom.TILE_ID.dirt
				
	return Biom.TILE_ID.grass

func spawn_enviroment():
	for _x in range(-10,10):
		for _y in range(-10,10):
			rng.randomize()
			if rng.randf() < 0.11:
				var x = _x *150
				var y = _y *150
				var pos = Vector2(x,y)
				_spawn_bush(pos)
				
	for _x in range(-10,10):
		for _y in range(-10,10):
			rng.randomize()
			if rng.randf() < 0.15:
				var x = _x *150
				var y = _y *150
				var pos = Vector2(x,y)
				_spawn_tree(pos)

 
func _spawn_tree(pos):
	var tree = preload("res://asset/terrain/tree/tree.tscn").instance()
	tree.position = pos
	add_child(tree)
	
func _spawn_bush(pos):
	var tree = preload("res://asset/terrain/bush/bush.tscn").instance()
	tree.position = pos
	add_child(tree)



