extends StaticBody2D
class_name CollectorBuilding

signal resource_collected(type,amount)

const target_resources = [
	Resources.RESOURCES_TYPE_FOOD,
	Resources.RESOURCES_TYPE_WOOD,
	Resources.RESOURCES_TYPE_MINERAL
]
onready var _sprite = $Sprite
onready var _collison = $CollisionShape2D
onready var _worker_spawn_position = $worker_spawn_position
onready var _drop_area = $Area2D
onready var _worker_holder = $worker_holder

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = {
	"name" : "Depot",
	"description" : "Building for worker to drop resources",
	"sprite" : "res://asset/collector/depot/depot.png",
	"worker_in_queue" : 5
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_sprite.texture = load(data.sprite)

func _on_worker_spawn_time_timeout():
	if data.worker_in_queue > 0:
		spawn_worker()
		data.worker_in_queue -= 1

func spawn_worker():
	for target_resource in target_resources:
		var worker = preload("res://asset/collector/worker/worker.tscn").instance()
		worker.position =_worker_spawn_position.position
		worker.drop_point = global_position
		worker.data.target_resources.append(target_resource)
		_worker_holder.add_child(worker)
	
	
func _on_Area2D_body_entered(body):
	if body is Worker:
		var resource = body.get_droped_resources()
		emit_signal("resource_collected", resource.type,resource.amount)
