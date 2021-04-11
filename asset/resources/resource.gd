extends StaticBody2D
class_name Resources

enum {
	RESOURCES_TYPE_FOOD,
	RESOURCES_TYPE_WOOD,
	RESOURCES_TYPE_MINERAL
}

onready var _sprite = $Sprite
onready var _icon = $icon

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = {
	"type" : RESOURCES_TYPE_FOOD,
	"name" : "",
	"description" : "",
	"sprite" : "res://asset/resources/farm/farm.png",
	"icon" : "res://asset/resources/farm/hay-icon.png",
	"amount" : 50.0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	match data.type:
		RESOURCES_TYPE_FOOD:
			data.sprite = "res://asset/resources/farm/farm.png"
			data.icon = "res://asset/resources/farm/hay-icon.png"
		RESOURCES_TYPE_WOOD:
			data.sprite = "res://asset/resources/tree/tree.png"
			data.icon = "res://asset/resources/tree/wood-icon.png"
		RESOURCES_TYPE_MINERAL:
			data.sprite = "res://asset/resources/mineral/iron.png"
			data.icon = "res://asset/resources/mineral/ore-icon.png"
			
	_sprite.texture = load(data.sprite)
	_icon.texture = load(data.icon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func take_resource():
	return data
