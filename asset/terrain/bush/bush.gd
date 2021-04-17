extends StaticBody2D



const BUSH_SPRITE_PATH = [
	"res://asset/terrain/bush/bush1.png",
	"res://asset/terrain/bush/bush2.png",
	"res://asset/terrain/bush/bush3.png",
	"res://asset/terrain/bush/bush4.png",
]

onready var rng = RandomNumberGenerator.new()
onready var _sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	_show_bush() # Replace with function body.


func _show_bush():
	rng.randomize()
	_sprite.texture = load(BUSH_SPRITE_PATH[rng.randf_range(0,BUSH_SPRITE_PATH.size())])
