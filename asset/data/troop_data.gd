extends Node
class_name TroopData

const CLASS_MELEE = 0
const CLASS_RANGE = 1

# data troop class
const TROOP_TYPE_SPEARMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 4.0,
	"hit_point" : 40.0,
	"armor" : 1.5,
	"range_attack" : 70,
	"attack_speed" : 2.0,
	"max_speed" : 90.0,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/spear.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_SWORDMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 7.0,
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
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_AXEMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 8.0,
	"hit_point" : 60.0,
	"armor" : 1.0,
	"range_attack" : 35,
	"attack_speed" : 1.3,
	"max_speed" : 140.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/no_armor.png",
	"head_sprite" : "res://asset/military/uniform/wolf_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/axe.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_ARCHER = {
	"class" : CLASS_RANGE,
	"attack_damage" : 2.0,
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
	"weapon_projectile_sprite":"res://asset/military/projectile/arrow/arrow.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_CROSSBOWMAN = {
	"class" : CLASS_RANGE,
	"attack_damage" : 6.0,
	"hit_point" : 80.0,
	"armor" : 3.0,
	"range_attack" : 320,
	"attack_speed" : 5.0,
	"max_speed" : 60.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/crossbow.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/bolt/bolt.png",
	"weapon_firing_sound":"res://asset/sound/arrow_fly.wav",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_MUSKETEER = {
	"class" : CLASS_RANGE,
	"attack_damage" : 8.0,
	"hit_point" : 40.0,
	"armor" : 1.0,
	"range_attack" : 380,
	"attack_speed" : 5.0,
	"max_speed" : 90.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/musket.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/bullet/bullet.png",
	"weapon_firing_sound":"res://asset/sound/cannon.wav",
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_LIGHT_CAVALRY = {
	"class" : CLASS_MELEE,
	"attack_damage" : 4.0,
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
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_HEAVY_CAVALRY = {
	"class" : CLASS_MELEE,
	"attack_damage" : 4.0,
	"hit_point" : 90.0,
	"armor" : 4.5,
	"range_attack" : 80,
	"attack_speed" : 3.0,
	"max_speed" : 160.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/sword.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/armored_horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
const TROOP_TYPE_ARCHER_CAVALRY = {
	"class" : CLASS_RANGE,
	"attack_damage" : 2.0,
	"hit_point" : 60.0,
	"armor" : 1.0,
	"range_attack" : 270,
	"attack_speed" : 5.0,
	"max_speed" : 230.0,
	"side" : "",
	"color" : Color(Color.red),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon_sprite":"res://asset/military/weapon/bow.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/arrow/arrow.png",
	"weapon_firing_sound":"",
	"mount_sprite":"res://asset/military/mount/horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0
	}
}
