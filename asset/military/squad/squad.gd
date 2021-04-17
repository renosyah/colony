extends KinematicBody2D
class_name Squad

# const
const dead_sound = [
	preload("res://asset/sound/maledeath1.wav"),
	preload("res://asset/sound/maledeath2.wav"),
	preload("res://asset/sound/maledeath3.wav"),
	preload("res://asset/sound/maledeath4.wav"),
]

const SQUAD_FORMATION_STANDAR = 0
const SQUAD_FORMATION_SPREAD = 1
const SQUAD_FORMATION_COMPACT = 2


signal on_squad_ready(squad)
signal on_squad_click()
signal on_squad_dead(side,squad)
signal on_squad_troop_dead(side,troop_left)


onready var rng = RandomNumberGenerator.new()
onready var _formation = preload("res://asset/military/formation/formation.gd").new()
onready var _animation = $AnimationPlayer
onready var _troop_holder = $troop_holder
onready var _banner = $banner
onready var _field_of_view = $Area2D
onready var _field_of_view_area = $Area2D/CollisionShape2D
onready var _audio = $AudioStreamPlayer2D
onready var _timer_target_damage = $timer_target_damage

var targets = []
var is_move = false
var waypoint = Vector2.ZERO
var formations
var min_area_waypoint = 5.0
var current_formation = SQUAD_FORMATION_STANDAR

# default data prevent null pointer
var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_empty.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_empty.png",
	"troop_amount" : 24,
	"formation_space" : 40,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 80.0,
	"attack_delay" : 1.0,
	"troop_data" : {}
}

func _ready():
	_banner.texture = load(data.banner_sprite)
	_banner.self_modulate = Color(data.color.r,data.color.g,data.color.b,data.color.a)
	_timer_target_damage.wait_time = data.attack_delay
	
	if data.troop_data["class"] == TroopData.CLASS_RANGE:
		_field_of_view_area.scale.x = 2.3
		_field_of_view_area.scale.y = 2.3
		
	spawn_full_squad()
	emit_signal("on_squad_ready", self)
	set_physics_process(false)
	
func _process(_delta):
	if is_move:
		var velocity = Vector2.ZERO
		var direction = (waypoint - global_position).normalized()
		var distance_to_waypoint = global_position.distance_to(waypoint)
		
		if distance_to_waypoint > min_area_waypoint:
			velocity = direction * _get_troop_data_mobility() * _delta
		
		if velocity != Vector2.ZERO:
			update_troop_position()
		
		move_and_collide(velocity)

func move_squad_to(pos):
	is_move = true
	waypoint = pos
	waypoint.y += 100.0
	waypoint.x += 50.0
	targets.clear()
	_field_of_view_area.disabled = true
	_field_of_view_area.disabled = false
	update_troop_facing_direction()

func set_selected(is_selected):
	if is_selected:
		_animation.play("squad_selected")
	else:
		_animation.play("squad_selected")
		_animation.seek(0.0)
		_animation.stop()
		
func change_formation(formation):
	#is_move = false
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
	rng.randomize()
	match current_formation:
		SQUAD_FORMATION_STANDAR:
			_display_chatter(Formation.FORMATION_BOX_CHATTER[rng.randf_range(0,Formation.FORMATION_BOX_CHATTER.size())])
			data.troop_data.bonus = Formation.FORMATION_BOX_BONUS
			
		SQUAD_FORMATION_SPREAD:
			_display_chatter(Formation.FORMATION_DELTA_CHATTER[rng.randf_range(0,Formation.FORMATION_DELTA_CHATTER.size())])
			data.troop_data.bonus = Formation.FORMATION_DELTA_BONUS
			
		SQUAD_FORMATION_COMPACT:
			_display_chatter(Formation.FORMATION_CIRCLE_CHATTER[rng.randf_range(0,Formation.FORMATION_CIRCLE_CHATTER.size())])
			data.troop_data.bonus = Formation.FORMATION_CIRCLE_BONUS
			
	for child in _troop_holder.get_children():
		child.set_bonus(data.troop_data.bonus)

func update_troop_position():
	var cur_formation = _get_formation(global_position,data.troop_amount,data.formation_space)
	var idx = 0
	for child in _troop_holder.get_children():
		child.is_rally_point = true
		child.target = cur_formation[idx].position
		idx += 1
		

func update_troop_facing_direction():
	for child in _troop_holder.get_children():
		child.set_facing_direction((waypoint - global_position).normalized())
		

func update_troop_target():
	if targets.empty():
		for child in _troop_holder.get_children():
			child.target = null
		return
		
	for child in _troop_holder.get_children():
		child.is_rally_point = false
		if !is_instance_valid(child.target):
			rng.randomize()
			child.target = targets[rng.randf_range(0,targets.size())].global_position
	
func set_random_target_damage():
	if !targets.empty():
		for child in _troop_holder.get_children():
			var target = targets[rng.randf_range(0,targets.size())]
			target.take_damage(_get_troop_data_attack_damage())


func _on_Area2D_body_entered(body):
	if body is Troop and body.data.side != data.side:
		targets.append(body)

func _on_Area2D_body_exited(body):
	if body is Troop:
		targets.erase(body)
	
	
func _on_timer_reset_target_timeout():
	update_troop_target()
	_disband_squad()
	
	
func _on_timer_target_damage_timeout():
	set_random_target_damage()


func _on_troop_dead():
	data.troop_amount = _troop_holder.get_children().size()
	emit_signal("on_squad_troop_dead",data.side, data.troop_amount)
	_play_dead_sound()
	_disband_squad()
	_display_chatter("-1 Unit")

func _disband_squad():
	if _troop_holder.get_children().empty():
		emit_signal("on_squad_dead",data.side, self)
		queue_free()

func _on_area_click_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.is_pressed()):
		emit_signal("on_squad_click")

func _play_dead_sound():
	rng.randomize()
	_audio.stream = dead_sound[rng.randf_range(0,dead_sound.size())]
	_audio.play()

func _get_troop_data_attack_damage():
	var dmg = data.troop_data.attack_damage + data.troop_data.bonus.attack
	if dmg < 0.0:
		dmg = 1.0
	return dmg
	
func _get_troop_data_mobility():
	var speed = data.troop_data.max_speed + data.troop_data.bonus.mobility
	if speed < 0.0:
		speed = 10.0
	return speed

func _display_chatter(text):
	var chatter = preload("res://asset/ui/squad_chatter/squad_chatter.tscn").instance()
	chatter.text = text
	chatter.position = _banner.position
	add_child(chatter)
	
	
func get_troop_left():
	if _troop_holder.get_children().empty():
		return data.troop_amount 
	return _troop_holder.get_children().size()
	
