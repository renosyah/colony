extends KinematicBody2D
class_name Troop

# example data
const TROOP_TYPE_SPEARMAN = {
	"attack_damage" : 4.0,
	"hit_point" : 80.0,
	"range_attack" : 60,
	"attack_speed" : 1.0,
	"side" : "",
	"color" : Color(Color.red),
	"max_speed" : 130.0,
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/spear.png"
}
const TROOP_TYPE_SWORDMAN = {
	"attack_damage" : 8.0,
	"hit_point" : 120.0,
	"range_attack" : 40,
	"attack_speed" : 1.5,
	"side" : "",
	"color" : Color(Color.red),
	"max_speed" : 110.0,
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/sword.png"
}

signal on_troop_dead()

onready var _body = $body
onready var _head = $body/head
onready var _weapon = $body/weapon
onready var _collision = $CollisionShape2D
onready var _attack_delay = $attack_delay
onready var _field_of_view = $Area2D/CollisionShape2D
onready var _animation = $AnimationPlayer

var target : KinematicBody2D = null
var rally_point : Vector2 = Vector2.ZERO
var range_folowing_distance = 20.0

var data = {
	"attack_damage" : 4.0,
	"hit_point" : 80.0,
	"range_attack" : 50,
	"attack_speed" : 1.0,
	"side" : "",
	"color" : Color(Color.red),
	"max_speed" : 150.0,
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/empty_weapon.png"
}

func _ready():
	_body.self_modulate = data.color
	_head.texture = load(data.head_sprite)
	_body.texture = load(data.body_sprite)
	_weapon.texture = load(data.weapon_sprite)

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if rally_point != Vector2.ZERO:
		var direction = (rally_point - global_position).normalized()
		var distance_to_rally_point = global_position.distance_to(rally_point)
			
		if distance_to_rally_point > range_folowing_distance:
			_animation.play("troop_walking")
			velocity = direction * data.max_speed * delta
			
			
	if is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		var distance_to_target = global_position.distance_to(target.global_position)
		
		if direction.x > 0:
			_body.scale.x = 1
		else:
			_body.scale.x = -1
			
		if distance_to_target > data.range_attack:
			_animation.play("troop_walking")
			velocity = direction * data.max_speed * delta

		if _attack_delay.is_stopped() and distance_to_target <= data.range_attack:
			target.take_damage(data.attack_damage)
			_animation.play("troop_attack")
			_attack_delay.wait_time = data.attack_speed
			_attack_delay.start()
	else:
		_animation.play("troop_walking")
		
	move_and_collide(velocity)

func take_damage(dmg):
	data.hit_point -= dmg
	if data.hit_point <= 0:
		emit_signal("on_troop_dead")
		queue_free()

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D and body.data.side != data.side:
		target = body

func _on_target_refresh_timeout():
	_field_of_view.disabled = true
	_field_of_view.disabled = false
	pass
