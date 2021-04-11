extends KinematicBody2D
class_name Worker

enum {
	TYPE_FOOD_WORKER,
	TYPE_WOOD_WORKER,
	TYPE_MINERAL_WORKER
}

var _target: StaticBody2D = null

onready var _body = $body
onready var _head = $body/head
onready var _item = $body/item
onready var _collision = $CollisionShape2D
onready var _animation = $AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var drop_point = Vector2.ZERO
var data = {
	"name" : "worker",
	"description" : "",
	"hit_point" : 90.0,
	"resource_in_hand" : null,
	"range_collect" : 50,
	"max_speed" : 130.0,
	"target_resources" : [],
	"side" : ""
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation.play("worker_walking")
	
func _physics_process(delta):
	_collision.disabled = (data.resource_in_hand == null)
	_item.visible = (data.resource_in_hand != null)
	var velocity = Vector2.ZERO
	
	if is_instance_valid(_target):
		var direction = (_target.global_position - global_position).normalized()
		var distance_to_target = global_position.distance_to(_target.global_position)
		
		if data.resource_in_hand:
			direction = (drop_point - global_position).normalized()
			distance_to_target = global_position.distance_to(drop_point)
			velocity = direction * data.max_speed * delta
		
		elif distance_to_target > data.range_collect:
			velocity = direction * data.max_speed * delta
			
		if distance_to_target <= data.range_collect and !data.resource_in_hand:
			var resource = _target.take_resource()
			check_type_resource(resource.type)
			data.resource_in_hand = resource
		
		_body.scale.x = direction.x

	move_and_collide(velocity)
	

func check_type_resource(type):
	match type:
		Resources.RESOURCES_TYPE_FOOD:
			_item.texture = load("res://asset/collector/depot/hay.png")
		Resources.RESOURCES_TYPE_WOOD:
			_item.texture = load("res://asset/collector/depot/log.png")
		Resources.RESOURCES_TYPE_MINERAL:
			_item.texture = load("res://asset/collector/depot/ore.png")

func get_droped_resources():
	var resource = data.resource_in_hand.duplicate()
	data.resource_in_hand = null
	return resource


func take_damage(dmg):
	data.hit_point -= dmg
	if data.hit_point <= 0:
		queue_free()


func _on_Area2D_body_entered(body):
	if body is Resources and data.target_resources.has(body.data.type):
		_target = body





