extends Node
class_name SquadData

# data troop squad class
const SQUAD_LIST = [{
	"name" : "Spearman",
	"description" : "Basic infantry unit arm with spear, has weak armor, and not effective again other class, but they are cheap",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 80.0,
	"attack_delay" : 2.0,
	"troop_data" : TroopData.TROOP_TYPE_SPEARMAN
}, {
	"name" : "Swordman",
	"description" : "Heavy infantry arm with two-handded sword with good armor and attack, efective for holding line, but with slow movement speed",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_swordman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_swordman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 80.0,
	"attack_delay" : 2.5,
	"troop_data" : TroopData.TROOP_TYPE_SWORDMAN
},{
	"name" : "Axeman",
	"description" : "Fastest infantry unit,arm with axe have excelent attack, but have no armor, efective for attacking enemy from flank",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_axeman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_axeman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 140.0,
	"attack_delay" : 1.3,
	"troop_data" : TroopData.TROOP_TYPE_AXEMAN
},{
	"name" : "Archer",
	"description" : "Basic range unit arm with bow for supporting other, because lack of armor it not suit for close quarter combat",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_archer.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_archer.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 80.0,
	"attack_delay" : 5.0,
	"troop_data" : TroopData.TROOP_TYPE_ARCHER
},{
	"name" : "Crossbowman",
	"description" : "Advance range unit arm with crossbow with high damage bolt for supporting other, unlike archer, this unit have some armor, so they can hold enemy in close quarter combat",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_crossbowman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_crossbowman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 80.0,
	"attack_delay" : 8.0,
	"troop_data" : TroopData.TROOP_TYPE_CROSSBOWMAN
},{
	"name" : "Musketeer",
	"description" : "Black powder range unit arm with musket, with very high dammage but low fire rate, have armor same as archer, its not suit for close combat",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_musketeer.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_musketeer.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 80.0,
	"attack_delay" : 12.0,
	"troop_data" : TroopData.TROOP_TYPE_MUSKETEER
},{
	"name" : "Light Cavalry",
	"description" : "Cavalry unit arm with lance, with little armor for great mobility, for quick hit-run attack style",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_light_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_light_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 180.0,
	"attack_delay" : 3.0,
	"troop_data" : TroopData.TROOP_TYPE_LIGHT_CAVALRY
},{
	"name" : "Heavy Cavalry",
	"description" : "Heavy Cavalry its basically swordman on horse, not as fast as light cavalry, but have armor and good attack",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_heavy_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_heavy_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 180.0,
	"attack_delay" : 3.0,
	"troop_data" : TroopData.TROOP_TYPE_HEAVY_CAVALRY
},{
	"name" : "Archer Cavalry",
	"description" : "Archer Cavalry arm with bow, great for supporting and other unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_archer_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_archer_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 180.0,
	"attack_delay" : 2.0,
	"troop_data" : TroopData.TROOP_TYPE_ARCHER_CAVALRY
},{
	"name" : "General",
	"description" : "Special unit with good defence and attack",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_leader.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_leader.png",
	"troop_amount" : 1,
	"formation_space" : 35,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 180.0,
	"attack_delay" : 3.0,
	"troop_data" : TroopData.TROOP_TYPE_GENERAL_CAVALRY
}]
