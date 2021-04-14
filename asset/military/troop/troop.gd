extends KinematicBody2D
class_name Troop

enum {
	CLASS_MELEE
	CLASS_RANGE
}

# data troop class
const TROOP_TYPE_SPEARMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 7.0,
	"hit_point" : 40.0,
	"armor" : 1.5,
	"range_attack" : 70,
	"attack_speed" : 2.0,
	"max_speed" : 90.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/spear.png",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}
const TROOP_TYPE_SWORDMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 10.0,
	"hit_point" : 100.0,
	"armor" : 5.0,
	"range_attack" : 40,
	"attack_speed" : 2.5,
	"max_speed" : 60.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/sword.png",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}
const TROOP_TYPE_AXEMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 14.0,
	"hit_point" : 70.0,
	"armor" : 1.0,
	"range_attack" : 35,
	"attack_speed" : 1.3,
	"max_speed" : 140.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/no_armor.png",
	"head_sprite" : "res://asset/military/uniform/wolf_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/axe.png",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}
const TROOP_TYPE_LIGHT_CAVALRY = {
	"class" : CLASS_MELEE,
	"attack_damage" : 7.0,
	"hit_point" : 80.0,
	"armor" : 1.5,
	"range_attack" : 80,
	"attack_speed" : 3.0,
	"max_speed" : 230.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/lance.png",
	"mount_sprite":"res://asset/military/mount/horse.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}
const TROOP_TYPE_ARCHER = {
	"class" : CLASS_RANGE,
	"attack_damage" : 4.0,
	"hit_point" : 40.0,
	"armor" : 1.0,
	"range_attack" : 380,
	"attack_speed" : 5.0,
	"max_speed" : 90.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/bow.png",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}
const TROOP_TYPE_CROSSBOWMAN = {
	"class" : CLASS_RANGE,
	"attack_damage" : 11.0,
	"hit_point" : 80.0,
	"armor" : 3.0,
	"range_attack" : 280,
	"attack_speed" : 5.0,
	"max_speed" : 60.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/crossbow.png",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}
const TROOP_TYPE_ARCHER_CAVALRY = {
	"class" : CLASS_RANGE,
	"attack_damage" : 2.0,
	"hit_point" : 60.0,
	"armor" : 1.0,
	"range_attack" : 240,
	"attack_speed" : 5.0,
	"max_speed" : 230.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/bow.png",
	"mount_sprite":"res://asset/military/mount/horse.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0
	}
}

const attack_melee_animations = [
	"troop_attack",
	"troop_attack_2",
	"troop_attack_3"
]

const attack_range_animations = [
	"troop_attack_bow"
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
const FORCE_MELEE_RANGE = 80.0

signal on_troop_dead()

onready var rng = RandomNumberGenerator.new()
onready var _body = $body
onready var _head = $body/head
onready var _weapon = $body/weapon
onready var _mount = $body/mount
onready var _collision = $CollisionShape2D
onready var _attack_delay = $attack_delay
onready var _animation = $AnimationPlayer
onready var _audio = $AudioStreamPlayer2D

var target = null
var is_rally_point = true

var data = {
	"class" : CLASS_MELEE,
	"attack_damage" : 4.0,
	"hit_point" : 80.0,
	"armor" : 80.0,
	"range_attack" : 50,
	"attack_speed" : 5.0,
	"side" : "",
	"color" : Color(Color.red),
	"max_speed" : 150.0,
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/empty_weapon.png",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack_damage" : 0,
		"armor" : 0,
	}
}

func _ready():
	_body.self_modulate = data.color
	_head.texture = load(data.head_sprite)
	_body.texture = load(data.body_sprite)
	_weapon.texture = load(data.weapon_sprite)
	_mount.texture = load(data.mount_sprite)
	_animation.play("troop_walking")
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
	if target:
		var direction = (target - global_position).normalized()
		var distance_to_target = global_position.distance_to(target)
		
		if is_rally_point and distance_to_target >= 5.0:
			_animation.play("troop_walking")
			velocity = direction * data.max_speed * delta

		elif distance_to_target > data.range_attack :
			_animation.play("troop_walking")
			velocity = direction * data.max_speed * delta
			if direction.x > 0:
				_body.scale.x = 1
			else:
				_body.scale.x = -1
			
		if _attack_delay.is_stopped() and !is_rally_point and distance_to_target <= data.range_attack:
			
			if direction.x > 0:
				_body.scale.x = 1
			else:
				_body.scale.x = -1
				
			match data.class:
				CLASS_MELEE:
					_play_figting_sound()
					_animation.play(attack_melee_animations[rng.randf_range(0,attack_melee_animations.size())])
				
				CLASS_RANGE:
					if distance_to_target > FORCE_MELEE_RANGE:
						_weapon.texture = load(data.weapon_sprite)
						_shoot(direction)
						_animation.play(attack_range_animations[rng.randf_range(0,attack_range_animations.size())])
					else:
						_weapon.texture = preload("res://asset/military/weapon/dagger.png")
						_play_figting_sound()
						_animation.play(attack_melee_animations[rng.randf_range(0,attack_melee_animations.size())])
				
			_attack_delay.wait_time = rand_range(1.0, data.attack_speed)
			_attack_delay.start()
	else:
		_animation.play("troop_walking")
		
	move_and_collide(velocity)

func _shoot(dir):
	var projectile = preload("res://asset/military/projectile/projectile.tscn").instance()
	projectile.side = data.side
	projectile.sprite = preload("res://asset/military/projectile/arrow/arrow.png")
	projectile.lauching(global_position, dir)
	add_child(projectile)

func hit_by_projectile():
	_play_stab_sound()

func take_damage(dmg):
	data.hit_point -=  _get_damage_receive(dmg)
	if data.hit_point <= 0:
		emit_signal("on_troop_dead")
		queue_free()

func _get_damage_receive(dmg):
	var _dmg = (dmg - (data.armor + data.bonus.armor))
	if _dmg < 0.0:
		_dmg =0.5
	return _dmg
	
func _play_figting_sound():
	rng.randomize()
	_audio.stream = combats_sound[rng.randf_range(0,combats_sound.size())]
	_audio.play()
	
func _play_stab_sound():
	rng.randomize()
	_audio.stream = stabs_sound[rng.randf_range(0,stabs_sound.size())]
	_audio.play()
