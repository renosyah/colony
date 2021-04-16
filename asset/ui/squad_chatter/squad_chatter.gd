extends Node2D

var speed = 100.0
var velocity = Vector2.ZERO

var text = ""
var color = Color(Color.white)

onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text
	label.modulate = color
	
func _process(delta):
	position.y += -1.0 * speed * delta

func _on_life_time_timeout():
	queue_free()
