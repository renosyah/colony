extends Node
class_name TroopData

const MAX_STATS = {
	"name" : "",
	"description" : "",
	"squad_icon" : "",
	"attack_damage" : 15.0,
	"hit_point" : 500.0,
	"armor" : 15.0,
	"range_attack" : 500.0,
	"max_speed" : 500.0
}

const CLASS_MELEE = 0
const CLASS_RANGE = 1

# data troop class
const TROOP_TYPE_PEASANT = {
	"class" : CLASS_MELEE,
	"attack_damage" : 1.0,
	"hit_point" : 10.0,
	"armor" : 0.0,
	"range_attack" : 75.0,
	"attack_delay" : 2.0,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/no_armor.png",
	"head_sprite" : "res://asset/military/uniform/no_armor_head.png",
	"weapon" : WeaponData.PITCHFORK,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_SPEARMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 4.0,
	"hit_point" : 40.0,
	"armor" : 1.0,
	"range_attack" : 80.0,
	"attack_delay" : 2.0,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm_3.png",
	"weapon" : WeaponData.SPEAR,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_MAN_AT_ARMS = {
	"class" : CLASS_MELEE,
	"attack_damage" : 5.0,
	"hit_point" : 40.0,
	"armor" : 1.2,
	"range_attack" : 50.0,
	"attack_delay" : 2.0,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon" : WeaponData.SHORT_SWORD,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_PIKEMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 6.5,
	"hit_point" : 40.0,
	"armor" : 2.8,
	"range_attack" : 95.0,
	"attack_delay" : 3.0,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/light_armor_helm.png",
	"weapon" : WeaponData.PIKE,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_SWORDMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 7.0,
	"hit_point" : 100.0,
	"armor" : 10.0,
	"range_attack" : 60.0,
	"attack_delay" : 2.5,
	"max_speed" : 25.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon" : WeaponData.LONG_SWORD,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_HALBERDIER = {
	"class" : CLASS_MELEE,
	"attack_damage" : 7.0,
	"hit_point" : 90.0,
	"armor" : 8.0,
	"range_attack" : 100.0,
	"attack_delay" : 2.5,
	"max_speed" : 25.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm_2.png",
	"weapon" : WeaponData.PIKE,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_AXEMAN = {
	"class" : CLASS_MELEE,
	"attack_damage" : 9.0,
	"hit_point" : 60.0,
	"armor" : 0.0,
	"range_attack" : 35.0,
	"attack_delay" : 1.3,
	"max_speed" : 60.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/no_armor.png",
	"head_sprite" : "res://asset/military/uniform/wolf_armor_helm.png",
	"weapon" : WeaponData.AXE,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_JAVELINEER = {
	"class" : CLASS_RANGE,
	"attack_damage" : 6.5,
	"hit_point" : 40.0,
	"armor" : 0.0,
	"range_attack" : 260.0,
	"attack_delay" : 5.0,
	"max_speed" : 60.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/no_armor.png",
	"head_sprite" : "res://asset/military/uniform/wolf_armor_helm.png",
	"weapon" : WeaponData.JAVELINE,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_ARCHER = {
	"class" : CLASS_RANGE,
	"attack_damage" : 4.5,
	"hit_point" : 40.0,
	"armor" : 1.0,
	"range_attack" : 380.0,
	"attack_delay" : 4.5,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon" : WeaponData.BOW,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_CROSSBOWMAN = {
	"class" : CLASS_RANGE,
	"attack_damage" : 8.0,
	"hit_point" : 80.0,
	"armor" : 3.0,
	"range_attack" : 320.0,
	"attack_delay" : 8.0,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon" : WeaponData.CROSSBOW,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_MUSKETEER = {
	"class" : CLASS_RANGE,
	"attack_damage" : 12.0,
	"hit_point" : 40.0,
	"armor" : 1.0,
	"range_attack" : 360.0,
	"attack_delay" : 11.0,
	"max_speed" : 40.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon" : WeaponData.MUSKET,
	"mount_sprite":"res://asset/military/mount/none.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_LIGHT_CAVALRY = {
	"class" : CLASS_MELEE,
	"attack_damage" : 6.0,
	"hit_point" : 80.0,
	"armor" : 1.5,
	"range_attack" : 110.0,
	"attack_delay" : 3.0,
	"max_speed" : 100.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/light_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm_2.png",
	"weapon" : WeaponData.LANCE,
	"mount_sprite":"res://asset/military/mount/horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_HEAVY_CAVALRY = {
	"class" : CLASS_MELEE,
	"attack_damage" : 7.5,
	"hit_point" : 90.0,
	"armor" : 9.5,
	"range_attack" : 70.0,
	"attack_delay" : 3.0,
	"max_speed" : 80.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon" : WeaponData.LONG_SWORD,
	"mount_sprite":"res://asset/military/mount/armored_horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_ARCHER_CAVALRY = {
	"class" : CLASS_RANGE,
	"attack_damage" : 3.0,
	"hit_point" : 60.0,
	"armor" : 1.0,
	"range_attack" : 350.0,
	"attack_delay" : 3.5,
	"max_speed" : 100.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/archer_armor.png",
	"head_sprite" : "res://asset/military/uniform/cap_armor_helm.png",
	"weapon" : WeaponData.BOW,
	"mount_sprite":"res://asset/military/mount/horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_MUSKET_CAVALRY = {
	"class" : CLASS_RANGE,
	"attack_damage" : 12.5,
	"hit_point" : 90.0,
	"armor" : 9.5,
	"range_attack" : 360.0,
	"attack_delay" : 15.0,
	"max_speed" : 80.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon" : WeaponData.MUSKET,
	"mount_sprite":"res://asset/military/mount/armored_horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
const TROOP_TYPE_GENERAL_CAVALRY = {
	"class" : CLASS_MELEE,
	"attack_damage" : 15.0,
	"hit_point" : 290.0,
	"armor" : 9.5,
	"range_attack" : 80.0,
	"attack_delay" : 3.0,
	"max_speed" : 80.0,
	"side" : "",
	"color" : Color(Color.white),
	"body_sprite" : "res://asset/military/uniform/heavy_armor.png",
	"head_sprite" : "res://asset/military/uniform/heavy_armor_helm.png",
	"weapon" : WeaponData.LONG_SWORD,
	"mount_sprite":"res://asset/military/mount/armored_horse.png",
	"bonus" : {
		"attack" : 0.0,
		"defence" : 0.0,
		"mobility" : 0.0,
		"attack_delay" : 0.0
	}
}
