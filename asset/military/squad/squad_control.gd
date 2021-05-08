extends KinematicBody2D

signal on_move(_position)
signal on_squad_click()

onready var _animation = $AnimationPlayer
onready var _banner = $banner
onready var _audio = $AudioStreamPlayer2D

var is_on_attack_mode = false
var is_move = false
var velocity = Vector2.ZERO
var waypoint = Vector2.ZERO
var min_area_waypoint = 5.0
var troop_attack_range = 0.0
var troop_mobility = 0.0

var squad_target = null

func set_waypoint(_wp):
	waypoint = _wp
	waypoint.y += 100.0
	waypoint.x += 50.0
	
func set_squad_target(_squad):
	squad_target = _squad
	set_waypoint(squad_target.get_position())
	
func set_status_mode(_is_move,_is_on_attack_mode):
	is_move = _is_move
	is_on_attack_mode = _is_on_attack_mode

func set_banner(data):
	_banner.texture = load(data.banner_sprite)
	_banner.self_modulate = data.color

func set_troop_attack_range(_troop_attack_range):
	troop_attack_range = _troop_attack_range
	
func set_troop_mobility(_troop_mobility):
	troop_mobility = _troop_mobility
	
func _ready():
	set_physics_process(false)

func set_selected(is_selected):
	if is_selected:
		_animation.play("squad_selected")
	else:
		_animation.play("squad_selected")
		_animation.seek(0.0)
		_animation.stop()
		
		
func change_banner_visual(_scale,_transparacy):
	_banner.self_modulate.a = _transparacy
	_banner.scale.x = _scale
	_banner.scale.y = _scale
	
func hide_banner():
	_banner.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if is_move:
		var direction = (waypoint - global_position).normalized()
		var distance_to_waypoint = global_position.distance_to(waypoint)
		
		if distance_to_waypoint > min_area_waypoint:
			velocity = direction * troop_mobility * delta
			
		if is_on_attack_mode and distance_to_waypoint <= troop_attack_range:
			velocity = Vector2.ZERO
			squad_target = null
			
		move_and_collide(velocity)
		
	if velocity != Vector2.ZERO and !is_on_attack_mode:
		emit_signal("on_move", global_position)
			
			
func _on_area_click_input_event(_viewport, event,_shape_idx):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		if _banner.self_modulate.a > 0.3:
			emit_signal("on_squad_click")
