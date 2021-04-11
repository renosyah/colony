extends KinematicBody2D
class_name Squad

const SQUAD_TYPE_SPEARMAN  = {
	"name" : "Spearman Squad",
	"description" : "Spearman Squad",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
	"troop_amount" : 15,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"troop_data" : Troop.TROOP_TYPE_SPEARMAN
}
const SQUAD_TYPE_SWORDMAN  = {
	"name" : "Swordman Squad",
	"description" : "Swordman Squad",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_swordman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_swordman.png",
	"troop_amount" : 15,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"troop_data" : Troop.TROOP_TYPE_SWORDMAN
}

signal on_squad_ready(squad)
signal on_squad_dead(squad)
signal on_squad_troop_dead(troop_left)

onready var _animation = $AnimationPlayer
onready var _troop_holder = $troop_holder
onready var _banner = $banner

var is_move = false
var waypoint = Vector2.ZERO
var min_area_waypoint = 10.0

var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_empty.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_empty.png",
	"troop_amount" : 24,
	"side" : "1",
	"color" : Color(Color.red),
	"max_speed" : 80.0,
	"troop_data" : {}
}

func _ready():
	_banner.texture = load(data.banner_sprite)
	_banner.self_modulate = data.color
	spawn_full_squad()
	emit_signal("on_squad_ready",self)
	
	
func _physics_process(_delta):
	if is_move:
		var velocity = Vector2.ZERO
		var direction = (waypoint - global_position).normalized()
		var distance_to_waypoint = global_position.distance_to(waypoint)
		
		if distance_to_waypoint > min_area_waypoint:
			velocity = direction * data.max_speed * _delta
			
		
		if velocity != Vector2.ZERO:
			update_troop_position()
		
		move_and_collide(velocity)
		
func set_selected(is_selected):
	if is_selected:
		_animation.play("squad_selected")
	else:
		_animation.seek(0.0)
		_animation.stop()
		
func spawn_full_squad():
	var number_of_unit = data.troop_amount
	var square_side_size = round(sqrt(number_of_unit))
	var space_between_units = 20
	var unit_pos = Vector2.ZERO - space_between_units * Vector2(square_side_size/2,square_side_size/2)
	
	for i in data.troop_amount:
		var troop = preload("res://asset/military/troop/troop.tscn").instance()
		troop.data = data.troop_data.duplicate()
		troop.data.side = data.side
		troop.data.color = data.color
		troop.connect("on_troop_dead", self , "_on_troop_dead")
		troop.position = unit_pos
		_troop_holder.add_child(troop)
		
		unit_pos.x += space_between_units
		if unit_pos.x > (Vector2.ZERO.x + square_side_size * space_between_units / 2):
			unit_pos.y += space_between_units
			unit_pos.x = Vector2.ZERO.x - space_between_units * square_side_size / 2

func update_troop_position():
	var number_of_unit = data.troop_amount
	var square_side_size = round(sqrt(number_of_unit))
	var space_between_units = 20
	var unit_pos = global_position - space_between_units * Vector2(square_side_size/2,square_side_size/2)
	
	for child in _troop_holder.get_children():
		child.rally_point = unit_pos
		
		unit_pos.x += space_between_units
		if unit_pos.x > (global_position.x + square_side_size * space_between_units / 2):
			unit_pos.y += space_between_units
			unit_pos.x = global_position.x - space_between_units * square_side_size / 2

func _on_troop_dead():
	emit_signal("on_squad_troop_dead", (_troop_holder.get_children().size() - 1))
	if _troop_holder.get_children().size() <= 1:
		emit_signal("on_squad_dead",self)
		queue_free()
