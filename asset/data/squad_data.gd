extends Node
class_name SquadData

# data troop squad class
const SQUAD_LIST = [{
	"name" : "Spearman",
	"description" : "Spearman Squad : medium, cheap, weak",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"attack_delay" : 2.0,
	"troop_data" : TroopData.TROOP_TYPE_SPEARMAN
}, {
	"name" : "Swordman",
	"description" : "Swordman Squad : slow, expensive, strong",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_swordman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_swordman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"attack_delay" : 2.5,
	"troop_data" : TroopData.TROOP_TYPE_SWORDMAN
},{
	"name" : "Axeman",
	"description" : "Axeman Squad : fast, expensive, weak",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_axeman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_axeman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 140.0,
	"attack_delay" : 1.3,
	"troop_data" : TroopData.TROOP_TYPE_AXEMAN
},{
	"name" : "Archer",
	"description" : "Archer Squad : basic range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_archer.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_archer.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"attack_delay" : 5.0,
	"troop_data" : TroopData.TROOP_TYPE_ARCHER
},{
	"name" : "Crossbowman",
	"description" : "Crossbowman Squad : advance range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_crossbowman.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_crossbowman.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"attack_delay" : 8.0,
	"troop_data" : TroopData.TROOP_TYPE_CROSSBOWMAN
},{
	"name" : "Musketeer",
	"description" : "Musketeer Squad : black powder range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_musketeer.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_musketeer.png",
	"troop_amount" : 15,
	"formation_space" : 20,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 80.0,
	"attack_delay" : 12.0,
	"troop_data" : TroopData.TROOP_TYPE_MUSKETEER
},{
	"name" : "Light Cavalry",
	"description" : "Light Cavalry : fast, expensive, light armor",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_light_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_light_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 180.0,
	"attack_delay" : 3.0,
	"troop_data" : TroopData.TROOP_TYPE_LIGHT_CAVALRY
},{
	"name" : "Heavy Cavalry",
	"description" : "Heavy Cavalry : medium, very expensive, armored",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_heavy_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_heavy_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 180.0,
	"attack_delay" : 3.0,
	"troop_data" : TroopData.TROOP_TYPE_HEAVY_CAVALRY
},{
	"name" : "Archer Cavalry",
	"description" : "Archer Cavalry : mounted range unit",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_archer_cavalry.png",
	"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_archer_cavalry.png",
	"troop_amount" : 15,
	"formation_space" : 35,
	"side" : "",
	"color" : Color(Color.white),
	"max_speed" : 180.0,
	"attack_delay" : 2.0,
	"troop_data" : TroopData.TROOP_TYPE_ARCHER_CAVALRY
}]
