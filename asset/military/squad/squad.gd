extends KinematicBody2D
class_name Squad

const SQUAD_FORMATION_STANDAR = 0
const SQUAD_FORMATION_SPREAD = 1
const SQUAD_FORMATION_COMPACT = 2

signal on_squad_ready(squad)
signal on_squad_click(squad)
signal on_squad_dead(squad)
signal on_squad_troop_dead(troop_left)
signal on_squad_scatter(is_scatter)

onready var rng = RandomNumberGenerator.new()
onready var _formation = preload("res://asset/military/formation/formation.gd").new()
onready var _animation = $AnimationPlayer
onready var _troop_holder = $troop_holder
onready var _dead_troop_holder = $dead_troop_holder
onready var _banner = $banner
onready var _field_of_view = $Area2D
onready var _field_of_view_area = $Area2D/CollisionShape2D
onready var _audio = $AudioStreamPlayer2D

var disposable_dead_body = null

var is_on_attack_mode = false
var is_scatter = false
var is_disbanded = false
var velocity = Vector2.ZERO
var targets = []
var is_move = false
var waypoint = Vector2.ZERO
var formations
var min_area_waypoint = 5.0
var current_formation = SQUAD_FORMATION_STANDAR

var data = {}

func _ready():
	_banner.texture = load(data.banner_sprite)
	_banner.self_modulate = data.color
	
	if data.troop_data["class"] == TroopData.CLASS_RANGE:
		_field_of_view_area.scale.x = 2.3
		_field_of_view_area.scale.y = 2.3
		
	_spawn_full_squad()
	set_physics_process(false)
	
func _process(_delta):
	velocity = Vector2.ZERO
	if is_move:
		var direction = (waypoint - global_position).normalized()
		var distance_to_waypoint = global_position.distance_to(waypoint)

		if distance_to_waypoint > min_area_waypoint:
			velocity = direction * _get_troop_data_mobility() * _delta
			
		move_and_collide(velocity)
		
	if velocity != Vector2.ZERO and !is_on_attack_mode:
		_update_troop_position()
		
		
func move_and_attack_to(_squad):
	if is_disbanded || is_scatter:
		return
	
	rng.randomize()
	_display_chatter(Formation.FORMATION_ASSAULT_CHATTER[rng.randf_range(0,Formation.FORMATION_ASSAULT_CHATTER.size())])
	
	is_on_attack_mode = true
	
	targets.clear()
	for target in _squad.get_troops():
		targets.append(target)
		
	_set_troop_max_enggangement_distance(INF)
	_update_troop_facing_direction()
	
func move_squad_to(pos):
	if is_disbanded || is_scatter:
		return
	
	is_on_attack_mode = false
	is_move = true
	waypoint = pos
	waypoint.y += 100.0
	waypoint.x += 50.0
	_field_of_view_area.disabled = true
	_field_of_view_area.disabled = false
	
	targets.clear()
	_set_troop_max_enggangement_distance(140.0)
	_update_troop_facing_direction()

func set_selected(is_selected):
	if is_disbanded || is_scatter:
		return
		
	if is_selected:
		_animation.play("squad_selected")
	else:
		_animation.play("squad_selected")
		_animation.seek(0.0)
		_animation.stop()
		
func change_formation(formation):
	if is_disbanded || is_scatter:
		return
		
	current_formation = formation
	_update_troop_position()
	_update_troop_formation_bonus()


func change_banner_visual(_scale,_transparacy):
	_banner.self_modulate.a = _transparacy
	_banner.scale.x = _scale
	_banner.scale.y = _scale

func _set_troop_max_enggangement_distance(_value):
	for troop in get_troops():
		troop.maximum_engagement_range = _value
		

func _get_formation(waypoint_position :Vector2 ,number_of_unit : int, space_between_units : int):
	match current_formation:
		SQUAD_FORMATION_STANDAR:
			return _formation.get_formation_box(waypoint_position,number_of_unit,space_between_units)
		SQUAD_FORMATION_SPREAD:
			return _formation.get_formation_box(waypoint_position,number_of_unit,space_between_units + 10)
		SQUAD_FORMATION_COMPACT:
			return _formation.get_formation_box(waypoint_position,number_of_unit, space_between_units - 5)
			
	return _formation.get_formation_box(waypoint_position,number_of_unit,space_between_units)


func _spawn_full_squad():
	var cur_formation = _formation.get_formation_box(Vector2.ZERO ,data.troop_amount ,data.formation_space)
	var idx = 0
	for i in data.troop_amount:
		var troop = preload("res://asset/military/troop/troop.tscn").instance()
		troop.data = data.troop_data.duplicate(true)
		troop.data.side = data.side
		troop.data.color = data.color
		troop.connect("on_troop_dead", self , "_on_troop_dead")
		troop.position = cur_formation[idx].position
		_troop_holder.add_child(troop)
		idx += 1
		
	emit_signal("on_squad_ready", self)


func _update_troop_formation_bonus():
	rng.randomize()
	match current_formation:
		SQUAD_FORMATION_STANDAR:
			#_display_chatter(Formation.FORMATION_BOX_CHATTER[rng.randf_range(0,Formation.FORMATION_BOX_CHATTER.size())])
			data.troop_data.bonus = Formation.FORMATION_BOX_BONUS
			
		SQUAD_FORMATION_SPREAD:
			#_display_chatter(Formation.FORMATION_DELTA_CHATTER[rng.randf_range(0,Formation.FORMATION_DELTA_CHATTER.size())])
			data.troop_data.bonus = Formation.FORMATION_DELTA_BONUS
			
		SQUAD_FORMATION_COMPACT:
			#_display_chatter(Formation.FORMATION_CIRCLE_CHATTER[rng.randf_range(0,Formation.FORMATION_CIRCLE_CHATTER.size())])
			data.troop_data.bonus = Formation.FORMATION_CIRCLE_BONUS
			
	for child in _troop_holder.get_children():
		child.set_bonus(data.troop_data.bonus)
		
		
func _update_troop_position():
	if is_disbanded || is_scatter:
		return
		
	var cur_formation = _get_formation(global_position,data.troop_amount,data.formation_space)
	var idx = 0
	for child in _troop_holder.get_children():
		child.rally_point = cur_formation[idx].position
		child.target = null
		idx += 1
		
func _make_troop_scatter():
	if is_scatter:
		return
		
	_display_chatter(Formation.FORMATION_SCATTER_CHATTER[rng.randf_range(0,Formation.FORMATION_SCATTER_CHATTER.size())])
	
	for child in _troop_holder.get_children():
		rng.randomize()
		var _scatter_x = global_position.x + rng.randf_range(rng.randf_range(-1200,-900), rng.randf_range(1200,1300))
		var _scatter_y = global_position.y + rng.randf_range(rng.randf_range(-1200,-900), rng.randf_range(1200,1300))
		child.rally_point = Vector2(_scatter_x,_scatter_y)
		child.target = null
		child.set_facing_direction((child.rally_point - global_position).normalized())

	is_scatter = true
	is_move = false
	_banner.visible = false
	is_disbanded = true
	targets.clear()
	
	emit_signal("on_squad_scatter", is_scatter)
	emit_signal("on_squad_dead", self)

func _update_troop_facing_direction():
	for child in _troop_holder.get_children():
		child.set_facing_direction((waypoint - global_position).normalized())

func _update_troop_target():
	if targets.empty() || is_disbanded || is_scatter:
		for child in _troop_holder.get_children():
			child.target = null
		return
		
	for child in _troop_holder.get_children():
		child.rally_point = null
		if is_instance_valid(child.target):
			if !child.target.is_alive:
				rng.randomize()
				child.target = targets[rng.randf_range(0,targets.size())]
		else:
			rng.randomize()
			child.target = targets[rng.randf_range(0,targets.size())]


func _on_Area2D_body_entered(body):
	if body is Troop and body.data.side != data.side:
		if targets.has(body):
			return
		if !body.is_alive:
			return
		targets.append(body)


func _on_Area2D_body_exited(body):
	if body is Troop:
		targets.erase(body)
	
	
func _on_timer_reset_target_timeout():
	_update_troop_target()
	_check_is_squad_need_to_disbanded()


func _on_troop_dead(troop):
	_relocate_troop_deadbody(troop)
	_notify_troop_dead()
	_decrease_squad_morale()
	_check_is_squad_need_to_disbanded()

func _notify_troop_dead():
	if is_disbanded || is_scatter:
		return
	data.troop_amount = get_troop_left()
	emit_signal("on_squad_troop_dead", data.troop_amount)


func _relocate_troop_deadbody(_troop):
	_troop_holder.remove_child(_troop)
	if disposable_dead_body:
		disposable_dead_body.add_child(_troop)
	else:
		_dead_troop_holder.add_child(_troop)

func _decrease_squad_morale():
	rng.randomize()
	if rng.randf() < 0.5:
		data.morale_point -= 1
		
	if data.morale_point <= 0:
		_make_troop_scatter()

func _check_is_squad_need_to_disbanded():
	if get_troop_left() <= 0:
		emit_signal("on_squad_dead",self)
		_banner.visible = false
		is_disbanded = true
		targets.clear()
		#queue_free()


func _on_area_click_input_event(_viewport, event,_shape_idx):
	if (event is InputEventScreenTouch and event.is_pressed()) or (event is InputEventMouseButton and event.is_action_pressed("left_click")):
		if _banner.self_modulate.a > 0.3:
			emit_signal("on_squad_click", self)

func _get_troop_data_attack_range():
	return data.troop_data.attack_range
	
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
	
	
func get_troops(): 
	return _troop_holder.get_children()
	
	
func get_troop_left(): 
	return _troop_holder.get_children().size()
	

