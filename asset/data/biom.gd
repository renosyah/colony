extends Node
class_name Biom


const GRASS_LAND = 0
const WET_LAND = 1
const MUD_LAND = 2
const URBAN_LAND = 3
 
const BIOMS = [
	{
		"id" : GRASS_LAND,
		"name" : "Grass",
		"sprite" : "res://asset/ui/map_biom/grass_land.png"
	},
	{
		"id" : WET_LAND,
		"name" : "Wet",
		"sprite" : "res://asset/ui/map_biom/grass_land.png"
	},
	{
		"id" : MUD_LAND,
		"name" : "Mud",
		"sprite" : "res://asset/ui/map_biom/grass_land.png"
	},
	{
		"id" : URBAN_LAND,
		"name" : "Urban",
		"sprite" : "res://asset/ui/map_biom/grass_land.png"
	}
]
const TILE_ID = {
	'grass' : 0,
	'mud' : 1,
	'water' : 2,
	'dirt' : 3,
	'wall' : 4,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
