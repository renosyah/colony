extends Node2D

signal on_animation_attack_performed()

onready var rng = RandomNumberGenerator.new()
onready var _sprite = $sprite
onready var _ammo = $sprite/ammo
onready var _animation = $AnimationPlayer
onready var _audio = $AudioStreamPlayer2D

var damage = 0.0
var _is_ready = false

var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_data(_data):
	data = _data
	_sprite.texture = load(data.weapon_sprite)
	_ammo.texture = load(data.weapon_projectile_sprite)

func do_nothing():
	_is_ready = false
	_animation.play("weapon_iddle")
	
func make_ready():
	if _is_ready:
		return
	_is_ready = true
	var _anim = data.ready_animation[rng.randf_range(0,data.ready_animation.size())]
	_animation.play(_anim)

func perform_attack():
	var _anim = data.attack_animation[rng.randf_range(0,data.attack_animation.size())]
	_animation.play(_anim)
	
	# by pass for melee weapon
	if data.weapon_type == WeaponData.CLASS_WEAPON_MELEE:
		emit_signal("on_animation_attack_performed")

func _on_animation_firing_performed():
	emit_signal("on_animation_attack_performed")
