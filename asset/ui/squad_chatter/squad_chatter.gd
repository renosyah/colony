extends Node2D

var speed = 100.0
var velocity = Vector2.ZERO

var is_large_text = true
var text = ""
var color = Color(Color.white)

onready var label_small = $Label2
onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label_small.text = text
	label_small.modulate = color
	
	label.text = text
	label.modulate = color
	
	label.visible = is_large_text
	label_small.visible = !is_large_text
	
func _process(delta):
	position.y += -1.0 * speed * delta

func _on_life_time_timeout():
	queue_free()
