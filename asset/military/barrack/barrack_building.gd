extends StaticBody2D

signal on_squad_ready(squad)

onready var _sprite = $Sprite
onready var _collison = $CollisionShape2D
onready var _spawn_position = $troop_spawn_position

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var data = {
	"name" : "Barrack",
	"description" : "Building for training spearman",
	"sprite" : "res://asset/military/barrack/barrack.png",
	"side" : "1",
	"color" : Color(Color.red),
	"squad_in_queue" : 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_sprite.texture = load(data.sprite)

func _on_squad_spawn_time_timeout():
	if data.squad_in_queue > 0:
		spawn_squad()
		data.squad_in_queue -= 1

func spawn_squad():
	var squad = preload("res://asset/military/squad/squad.tscn").instance()
	squad.data.side = data.side
	squad.data.color = data.color
	squad.position = _spawn_position.position
	emit_signal("on_squad_ready",squad)
	add_child(squad)
