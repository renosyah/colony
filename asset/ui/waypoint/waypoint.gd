extends Node2D

onready var _sprite = $Sprite
onready var _animation = $AnimationPlayer

var color = Color(Color.white)

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation.play("waypoint_change_size")
	_sprite.modulate = color
 
func _on_life_time_timeout():
	queue_free()
