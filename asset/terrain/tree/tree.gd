extends StaticBody2D


const TREE_SPRITE_PATH = [
	"res://asset/terrain/tree/tree1.png",
	"res://asset/terrain/tree/tree2.png",
	"res://asset/terrain/tree/tree3.png",
	"res://asset/terrain/tree/tree4.png",
	"res://asset/terrain/tree/tree5.png"
]

onready var rng = RandomNumberGenerator.new()
onready var _sprite = $Sprite

func _ready():
	_show_tree()
	
func _show_tree():
	rng.randomize()
	_sprite.texture = load(TREE_SPRITE_PATH[rng.randf_range(0,TREE_SPRITE_PATH.size())])
