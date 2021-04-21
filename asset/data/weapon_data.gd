extends Node
class_name WeaponData

const CLASS_WEAPON_MELEE = 0
const CLASS_WEAPON_RANGE = 1

# polearms
const SPEAR = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/spear.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" : "weapon_polearm_trusting",
}
const PIKE = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/pike.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" : "weapon_polearm_trusting",
}
const LANCE = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/lance.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" : "weapon_polearm_trusting",
}


# special purpose
const DAGGER = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/dagger.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_sword_slashing"
}
const AXE = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/axe.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_sword_slashing"
}


# sword
const SHORT_SWORD = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/short_sword.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_sword_slashing"
}
const LONG_SWORD = {
	"weapon_type" : CLASS_WEAPON_MELEE,
	"weapon_sprite":"res://asset/military/weapon/sword.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_sword_slashing"
}


# bow
const BOW = {
	"weapon_type" : CLASS_WEAPON_RANGE,
	"weapon_sprite":"res://asset/military/weapon/bow.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/arrow/arrow.png",
	"weapon_firing_sound": "res://asset/sound/arrow_fly.wav",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_bow_firing"
}
# javeline
const JAVELINE = {
	"weapon_type" : CLASS_WEAPON_RANGE,
	"weapon_sprite":"res://asset/military/projectile/javeline/javelin.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/javeline/javelin.png",
	"weapon_firing_sound": "res://asset/sound/arrow_fly.wav",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_throwing"
}
# cross bow
const CROSSBOW = {
	"weapon_type" : CLASS_WEAPON_RANGE,
	"weapon_sprite":"res://asset/military/weapon/crossbow.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/bolt/bolt.png",
	"weapon_firing_sound": "res://asset/sound/arrow_fly.wav",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_crossbow_firing"
}
# firearms
const MUSKET = {
	"weapon_type" : CLASS_WEAPON_RANGE,
	"weapon_sprite":"res://asset/military/weapon/musket.png",
	"weapon_projectile_sprite":"res://asset/military/projectile/empty.png",
	"weapon_firing_sound": "res://asset/sound/cannon.wav",
	"ready_animation" : "weapon_iddle",
	"attack_animation" :"weapon_musket_firing"
}
