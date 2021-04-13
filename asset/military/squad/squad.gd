extends KinematicBody2D
class_name Squad

# data troop squad class
const SQUAD_TYPE_SPEARMAN  = {
	"name" : "Spearman",
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
	"name" : "Swordman",
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
	"name" : "Axeman",
	"description" : "Axeman Squad : fast, expensive, weak",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_axeman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_axeman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 100.0,
	"troop_data" : Troop.TROOP_TYPE_AXEMAN
}
const SQUAD_TYPE_LIGHT_CAVALRY = {
	"name" : "Light Cavalry",
	"description" : "Light Cavalry : fast, expensive, medium",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_light_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_light_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 180.0,
	"troop_data" : Troop.TROOP_TYPE_LIGHT_CAVALRY
}
const SQUAD_TYPE_ARCHER = {
	"name" : "Archer",
	"description" : "Archer Squad : basic range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_archer.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_archer.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"troop_data" : Troop.TROOP_TYPE_ARCHER
}
const SQUAD_TYPE_CROSSBOWMAN = {
	"name" : "Crossbowman",
	"description" : "Crossbowman Squad : advance range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_crossbowman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_crossbowman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"troop_data" : Troop.TROOP_TYPE_CROSSBOWMAN
}
const SQUAD_TYPE_ARCHER_CAVALRY = {
	"name" : "Archer Cavalry",
	"description" : "Archer Cavalry : mounted range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_archer_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_archer_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 180.0,
	"troop_data" : Troop.TROOP_TYPE_ARCHER_CAVALRY
}

# const
const dead_sound = [
	preload("res://asset/sound/maledeath1.wav"),
	preload("res://asset/sound/maledeath2.wav"),
	preload("res://asset/sound/maledeath3.wav"),
	preload("res://asset/sound/maledeath4.wav"),
]

enum {
	SQUAD_FORMATION_STANDAR,
	SQUAD_FORMATION_SPREAD,
	SQUAD_FORMATION_COMPACT
}

signal on_squad_ready(squad)
signal on_squad_click()
signal on_squad_dead(squad)
signal on_squad_troop_dead(side,troop_left)


onready var rng = RandomNumberGenerator.new()
onready var _formation = preload("res://asset/military/formation/formation.gd").new()
onready var _animation = $AnimationPlayer
onready var _troop_holder = $troop_holder
onready var _banner = $banner
onready var _field_of_view = $Area2D
onready var _field_of_view_area = $Area2D/CollisionShape2D
onready var _audio = $AudioStreamPlayer2D

var targets = []
var is_move = false
var waypoint = Vector2.ZERO
var formations
var min_area_waypoint = 5.0
var current_formation = SQUAD_FORMATION_STANDAR

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
	change_formation(SQUAD_FORMATION_STANDAR)
	emit_signal("on_squad_ready",self)
	if data.troop_data["class"] == Troop.CLASS_RANGE:
		_field_of_view_area.scale.x = 1.8
		_field_of_view_area.scale.y = 1.8
	
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

func move_squad_to(pos):
	is_move = true
	waypoint = pos
	update_troop_faccing_direction()
	_field_of_view.monitorable = false
	_field_of_view.monitorable = true

func set_selected(is_selected):
	if is_selected:
		_animation.play("squad_selected")
	else:
		_animation.play("squad_selected")
		_animation.seek(0.0)
		_animation.stop()
		
func change_formation(formation):
	is_move = false
	current_formation = formation
	update_troop_position()
	update_troop_formation_bonus(formation)

func _get_formation(waypoint_position :Vector2 ,number_of_unit : int, space_between_units : int):
	match current_formation:
		SQUAD_FORMATION_STANDAR:
			return _formation.get_formation_box(waypoint_position,number_of_unit,space_between_units)
		SQUAD_FORMATION_SPREAD:
			return _formation.get_formation_box(waypoint_position,number_of_unit,space_between_units + 10)
		SQUAD_FORMATION_COMPACT:
			return _formation.get_formation_box(waypoint_position,number_of_unit, space_between_units - 5)
			
	return _formation.get_formation_box(waypoint_position,number_of_unit,space_between_units)

func spawn_full_squad():
	var cur_formation = _formation.get_formation_box(Vector2.ZERO ,data.troop_amount ,data.formation_space)
	var idx = 0
	for i in data.troop_amount:
		var troop = preload("res://asset/military/troop/troop.tscn").instance()
		troop.data = data.troop_data.duplicate()
		troop.data.side = data.side
		troop.data.color = data.color
		troop.connect("on_troop_dead", self , "_on_troop_dead")
		troop.position = cur_formation[idx].position
		_troop_holder.add_child(troop)
		idx += 1

func update_troop_formation_bonus(formation):
	for child in _troop_holder.get_children():
		match current_formation:
			SQUAD_FORMATION_STANDAR:
				child.set_bonus(Formation.FORMATION_BOX_BONUS)
			SQUAD_FORMATION_SPREAD:
				child.set_bonus(Formation.FORMATION_DELTA_BONUS)
			SQUAD_FORMATION_COMPACT:
				child.set_bonus(Formation.FORMATION_CIRCLE_BONUS)

func update_troop_position():
	var cur_formation = _get_formation(global_position,data.troop_amount,data.formation_space)
	var idx = 0
	for child in _troop_holder.get_children():
		child.rally_point = cur_formation[idx].position
		idx += 1
		

func update_troop_faccing_direction():
	for child in _troop_holder.get_children():
		child.set_facing_direction((waypoint - global_position).normalized())
		

func update_troop_target():
	rng.randomize()
	for child in _troop_holder.get_children():
		child.rally_point = null
		if targets.size() <= 0:
			child.target = null
		else:
			child.target = targets[rng.randf_range(0,targets.size())]
	
func _on_Area2D_body_entered(body):
	if body is Troop and body.data.side != data.side:
		targets.append(body)
		update_troop_target()

func _on_Area2D_body_exited(body):
	if body is Troop:
		targets.erase(body)
	
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


