extends Node2D

signal on_animation_attack_performed()

onready var _sprite = $sprite
onready var _ammo = $sprite/ammo
onready var _animation = $AnimationPlayer
onready var _audio = $AudioStreamPlayer2D

var damage = 0.0

var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_data(_data):
	data = _data
	_sprite.texture = load(data.weapon_sprite)
	_ammo.texture = load(data.weapon_projectile_sprite)

func do_nothing():
	_animation.play(data.ready_animation)

func perform_attack():
	_animation.play(data.attack_animation)
	
	# by pass for melee weapon
	if data.weapon_type == WeaponData.CLASS_WEAPON_MELEE:
		emit_signal("on_animation_attack_performed")

func _on_animation_firing_performed():
	emit_signal("on_animation_attack_performed")
