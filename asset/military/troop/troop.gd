extends KinematicBody2D
class_name Troop

const dead_animations = [
	"troop_dead",
	"troop_dead_2"
]
# const
const dead_sound = [
	preload("res://asset/sound/maledeath1.wav"),
	preload("res://asset/sound/maledeath2.wav"),
	preload("res://asset/sound/maledeath3.wav"),
	preload("res://asset/sound/maledeath4.wav"),
]
const combats_sound = [
	preload("res://asset/sound/fight1.wav"),
	preload("res://asset/sound/fight2.wav"),
	preload("res://asset/sound/fight3.wav"),
	preload("res://asset/sound/fight4.wav"),
	preload("res://asset/sound/fight5.wav")
]
const stabs_sound = [
	preload("res://asset/sound/stab1.wav"),
	preload("res://asset/sound/stab2.wav"),
]
const MAXIMUM_ENGAGEMENT_RANGE = 250.0

signal on_troop_dead(troop)

onready var rng = RandomNumberGenerator.new()
onready var _body = $body
onready var _head = $body/head
onready var _weapon = $body/weapon
onready var _mount = $body/mount
onready var _collision = $CollisionShape2D
onready var _attack_delay = $attack_delay
onready var _animation = $AnimationPlayer
onready var _audio = $AudioStreamPlayer2D


var is_alive = true
var _last_position = Vector2.ZERO
var target : KinematicBody2D = null
var rally_point = null

var data = {}

func _ready():
	_body.self_modulate = data.color
	_head.texture = load(data.head_sprite)
	_body.texture = load(data.body_sprite)
	_mount.texture = load(data.mount_sprite)
	_animation.play("troop_walking")
	_weapon.set_data(data.weapon)
	set_physics_process(false)
	
func set_bonus(bon):
	data.bonus = bon
	
func set_facing_direction(_direction):
	if _direction.x > 0:
		_body.scale.x = 1
	else:
		_body.scale.x = -1


func _process(delta):
	var velocity = Vector2.ZERO
	var direction = Vector2.ZERO
	var distance_to_target = 0.0
	
	if !is_alive:
		global_position = _last_position
		return
		
	if rally_point:
		direction = (rally_point - global_position).normalized()
		distance_to_target = global_position.distance_to(rally_point)
		
		if distance_to_target > 5.0:
			_weapon.do_nothing()
			_animation.play("troop_walking")
			velocity = direction * _get_troop_data_mobility() * delta
			
	elif target:
		direction = (target.global_position - global_position).normalized()
		distance_to_target = global_position.distance_to(target.global_position)
		var distance_to_parent = global_position.distance_to(get_parent().get_parent().global_position)
		
		if distance_to_target > data.range_attack and distance_to_parent < MAXIMUM_ENGAGEMENT_RANGE:
			_weapon.make_ready()
			_animation.play("troop_walking")
			velocity = direction * _get_troop_data_mobility() * delta
			set_facing_direction(direction)
			
		if _attack_delay.is_stopped() and distance_to_target <= data.range_attack and target.is_alive:
			set_facing_direction(direction)
			_start_combat(target,direction,distance_to_target)
			_attack_delay.wait_time = _get_troop_data_attack_delay()
			_attack_delay.start()

	else:
		_weapon.do_nothing()
		_animation.play("troop_walking")
		
	move_and_collide(velocity)

func _start_combat(_target, _direction, _distance):
	
	if data["class"] == TroopData.CLASS_MELEE:
		_weapon.perform_attack()
		_target.take_damage(_get_troop_data_attack_damage())
		_play_fighting_sound()
		
	elif data["class"] == TroopData.CLASS_RANGE:
		_weapon.perform_attack()
		yield(_weapon,"on_animation_attack_performed")
		if is_instance_valid(_target):
			_play_weapon_firing()
			_shoot_at(_target)
			
	_animation.play("troop_walking")

func _shoot_at(_target):
	var direction = (_target.global_position - global_position).normalized()
	var projectile = preload("res://asset/military/projectile/projectile.tscn").instance()
	projectile.side = data.side
	projectile.damage = _get_troop_data_attack_damage()
	projectile.sprite = load(data.weapon.weapon_projectile_sprite)
	projectile.lauching(global_position, direction)
	add_child(projectile)

func hit_by_projectile(_projectile_sprite):
	if rng.randf() < 0.4 and data.hit_point <= 10.0:
		_attach_projectile(_projectile_sprite)
	#_play_stab_sound()

func _attach_projectile(_projectile_sprite):
	var _projectile_attach = Sprite.new()
	_projectile_attach.texture = _projectile_sprite
	_projectile_attach.rotate(rand_range(-0.10, 0.10))
	_projectile_attach.flip_h = true
	_projectile_attach.scale.x = 0.8
	_projectile_attach.scale.y = 0.8
	_projectile_attach.offset = Vector2(rand_range(8.0, 10.0),rand_range(-4, -10))
	_projectile_attach.show_behind_parent = true
	_body.add_child(_projectile_attach)

func take_damage(dmg):
	var _dmg = _get_damage_receive(dmg)
	data.hit_point -= _dmg
	if data.hit_point <= 0 and is_alive:
		_set_dead()

func _set_dead():
	is_alive = false
	_last_position = global_position
	_weapon.do_nothing()
	_play_troop_dead_animation()
	
func _play_troop_dead_animation():
	
	_play_dead_sound()

	_animation.play(dead_animations[rng.randf_range(0,dead_animations.size())])
	yield(_animation,"animation_finished")
	
	if rng.randf() < 0.5:
		_body.rotation_degrees = rand_range(-90, 90)
		_weapon.rotation_degrees = rand_range(-90, 90)
		
	emit_signal("on_troop_dead", self)
	_collision.disabled = true
	#queue_free()
	
func _get_troop_data_attack_damage():
	var dmg = data.attack_damage + data.bonus.attack
	if dmg < 0.0:
		dmg = 1.0
	return dmg
	
func _get_troop_data_attack_delay():
	var delay = data.attack_delay + data.bonus.attack_delay
	if delay < 0.0:
		delay = 0.5
	return delay
	
func _get_troop_data_mobility():
	var speed = data.max_speed + data.bonus.mobility
	if speed < 0.0:
		speed = 10.0
	return speed
	
func _get_damage_receive(dmg):
	var _dmg = (dmg - (data.armor + data.bonus.defence))
	if _dmg < 0.0:
		_dmg =0.5
	return _dmg
	
func _play_weapon_firing():
	if data.weapon.weapon_firing_sound == "":
		return
		
	_audio.stream = load(data.weapon.weapon_firing_sound)
	_audio.play()
	
func _play_fighting_sound():
	rng.randomize()
	_audio.stream = combats_sound[rng.randf_range(0,combats_sound.size())]
	_audio.play()
	
func _play_stab_sound():
	rng.randomize()
	_audio.stream = stabs_sound[rng.randf_range(0,stabs_sound.size())]
	_audio.play()
	
func _play_dead_sound():
	rng.randomize()
	_audio.stream = dead_sound[rng.randf_range(0,dead_sound.size())]
	_audio.play()
