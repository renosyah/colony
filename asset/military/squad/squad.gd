extends KinematicBody2D
class_name Squad

# data troop squad class
const SQUAD_TYPE_SPEARMAN  = {
	"name" : "Spearman Squad",
	"description" : "Spearman Squad : medium, cheap, weak",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"troop_data" : Troop.TROOP_TYPE_SPEARMAN
}
const SQUAD_TYPE_SWORDMAN  = {
	"name" : "Swordman Squad",
	"description" : "Swordman Squad : slow, expensive, strong",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_swordman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_swordman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"troop_data" : Troop.TROOP_TYPE_SWORDMAN
}
const SQUAD_TYPE_AXEMAN  = {
	"name" : "Axeman Squad",
	"description" : "Axeman Squad : fast, expensive, weak",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_axeman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_axeman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 90.0,
	"troop_data" : Troop.TROOP_TYPE_AXEMAN
}

# const
const dead_sound = [
	preload("res://asset/sound/maledeath1.wav"),
	preload("res://asset/sound/maledeath2.wav"),
	preload("res://asset/sound/maledeath3.wav"),
	preload("res://asset/sound/maledeath4.wav"),
]

signal on_squad_ready(squad)
signal on_squad_click()
signal on_squad_dead(squad)
signal on_squad_troop_dead(side,troop_left)

onready var rng = RandomNumberGenerator.new()
onready var _animation = $AnimationPlayer
onready var _troop_holder = $troop_holder
onready var _banner = $banner
onready var _field_of_view = $Area2D
onready var _audio = $AudioStreamPlayer2D

var targets = []
var is_move = false
var waypoint = Vector2.ZERO
var min_area_waypoint = 5.0

var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_empty.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_empty.png",
	"troop_amount" : 24,
	"formation_space" : 40,
	"side" : "",
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
			
		update_troop_position(velocity != Vector2.ZERO)
			
		move_and_collide(velocity)

func set_selected(is_selected):
	if is_selected:
		_animation.play("squad_selected")
	else:
		_animation.play("squad_selected")
		_animation.seek(0.0)
		_animation.stop()
		
func spawn_full_squad():
	var number_of_unit = data.troop_amount
	var square_side_size = round(sqrt(number_of_unit))
	var space_between_units = data.formation_space
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

func update_troop_position(is_set):
	var number_of_unit =  (_troop_holder.get_children().size() - 1)
	var square_side_size = round(sqrt(number_of_unit))
	var space_between_units = data.formation_space
	var unit_pos = position - space_between_units * Vector2(square_side_size/2,square_side_size/2)
	
	for child in _troop_holder.get_children():
		if is_set:
			child.rally_point = unit_pos
		else:
			child.rally_point = null
		
		unit_pos.x += space_between_units
		if unit_pos.x > (position.x + square_side_size * space_between_units / 2):
			unit_pos.y += space_between_units
			unit_pos.x = position.x - space_between_units * square_side_size / 2

func update_troop_target():
	rng.randomize()
	for child in _troop_holder.get_children():
		if targets.size() <= 0:
			child.target = null
		else:
			child.target = targets[rng.randf_range(0,targets.size())]
	
func _on_Area2D_body_entered(body):
	if body is Troop and body.data.side != data.side:
		targets.append(body)
		update_troop_target()

func _on_timer_reset_target_timeout():
	update_troop_target()
	
func _on_troop_dead():
	emit_signal("on_squad_troop_dead",data.side, (_troop_holder.get_children().size() - 1))
	play_dead_sound()
	if _troop_holder.get_children().size() <= 1:
		emit_signal("on_squad_dead",self)
		queue_free()


func _on_area_click_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.is_pressed()):
		emit_signal("on_squad_click")

func play_dead_sound():
	rng.randomize()
	_audio.stream = dead_sound[rng.randf_range(0,dead_sound.size())]
	_audio.play()
