extends Node
class_name BattleData

const file_name= "user://battle_data.json";
const save_file_password = "fwegfuywe7r632r732fdjghfvjhfesedwfcdewqyhfewjf"

const PLAYER_SIDE_TAG = "PLAYER"
const BOT_SIDE_TAG = "BOT"

const TYPE_QUICK_BATTLE = "TYPE_QUICK_BATTLE"

var battle_data = {
	"type" : TYPE_QUICK_BATTLE,
	"name" : "",
	"bot_setting" : {},
	"biom" : 0,
	"battle" : {
		PLAYER_SIDE_TAG : {
			"name" : "",
			"color" : {},
			"squads": [],
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		},
		BOT_SIDE_TAG : {
			"name" : "",
			"color" : {},
			"squads": [],
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		}
	},
	"post_battle" : {
		PLAYER_SIDE_TAG : {
			"name" : "",
			"color" : {},
			"squads": [],
			"troop_remain" : 0,
			"troop_kill" : 0,
			"troop_lost" : 0,
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		},
		BOT_SIDE_TAG : {
			"name" : "",
			"color" : {},
			"squads": [],
			"troop_remain" : 0,
			"troop_kill" : 0,
			"troop_lost" : 0,
			"position" : {
				"x" : 0.0,
				"y" : 0.0,
			}
		}
	}
}

func save_battle():
	var file = File.new()
	file.open_encrypted_with_pass(file_name, File.WRITE, save_file_password)
	file.store_var(to_json(battle_data), true)
	file.close()

func load_battle():
	var loadParam = null
	var file = File.new()
	if not file.file_exists(file_name):
		return loadParam
	file.open_encrypted_with_pass(file_name, File.READ,save_file_password)
	loadParam = parse_json(file.get_var(true))
	file.close()
	return loadParam

func delete():
	var dir = Directory.new()
	dir.remove(file_name)
	
# example data
#{
#	"type" : BattleData.TYPE_QUICK_BATTLE,
#	"name" : "Battle of cairo",
#	"bot_setting" : BotSetting.EASY_SETTING,
#	"battle" : {
#		BattleData.PLAYER_SIDE_TAG : {
#			"name" : "melvin",
#			"color" : {
#				"r": Color.blue.r,
#				"g": Color.blue.g,
#				"b": Color.blue.b,
#				"a": Color.blue.a
#			},
#			"squads": [{
#				"name" : "Spearman",
#				"description" : "Basic infantry unit arm with spear, has weak armor, and not effective again other class, but they are cheap",
#				"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
#				"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
#				"troop_amount" : 15,
#				"formation_space" : 20,
#				"side" : BattleData.PLAYER_SIDE_TAG,
#				"color" : {
#					"r": Color.blue.r,
#					"g": Color.blue.g,
#					"b": Color.blue.b,
#					"a": Color.blue.a
#				},
#				"max_speed" : 80.0,
#				"attack_delay" : 2.0,
#				"troop_data" : TroopData.TROOP_TYPE_SPEARMAN.duplicate()
#			},
#			{
#				"name" : "Spearman",
#				"description" : "Basic infantry unit arm with spear, has weak armor, and not effective again other class, but they are cheap",
#				"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
#				"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
#				"troop_amount" : 15,
#				"formation_space" : 20,
#				"side" : BattleData.PLAYER_SIDE_TAG,
#				"color" : {
#					"r": Color.blue.r,
#					"g": Color.blue.g,
#					"b": Color.blue.b,
#					"a": Color.blue.a
#				},
#				"max_speed" : 80.0,
#				"attack_delay" : 2.0,
#				"troop_data" : TroopData.TROOP_TYPE_SPEARMAN.duplicate()
#			},
#			{
#				"name" : "Spearman",
#				"description" : "Basic infantry unit arm with spear, has weak armor, and not effective again other class, but they are cheap",
#				"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
#				"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
#				"troop_amount" : 15,
#				"formation_space" : 20,
#				"side" : BattleData.PLAYER_SIDE_TAG,
#				"color" : {
#					"r": Color.blue.r,
#					"g": Color.blue.g,
#					"b": Color.blue.b,
#					"a": Color.blue.a
#				},
#				"max_speed" : 80.0,
#				"attack_delay" : 2.0,
#				"troop_data" : TroopData.TROOP_TYPE_SPEARMAN.duplicate()
#			}],
#			"position" : {
#				"x" : 0.0,
#				"y" : 0.0,
#			}
#		},
#		BattleData.BOT_SIDE_TAG : {
#			"name" : "",
#			"color" : {
#				"r": Color.red.r,
#				"g": Color.red.g,
#				"b": Color.red.b,
#				"a": Color.red.a
#			},
#			"squads": [{
#				"name" : "Spearman",
#				"description" : "Basic infantry unit arm with spear, has weak armor, and not effective again other class, but they are cheap",
#				"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_spearman.png",
#				"banner_sprite" : "res://asset/ui/banners/squad_banners/banner_spearman.png",
#				"troop_amount" : 15,
#				"formation_space" : 20,
#				"side" : BattleData.BOT_SIDE_TAG,
#				"color" : {
#					"r": Color.red.r,
#					"g": Color.red.g,
#					"b": Color.red.b,
#					"a": Color.red.a
#				},
#				"max_speed" : 80.0,
#				"attack_delay" : 2.0,
#				"troop_data" : TroopData.TROOP_TYPE_SPEARMAN.duplicate()
#			}],
#			"position" : {
#				"x" : 0.0,
#				"y" : 0.0,
#			}
#		}
#	},
#	"post_battle" : {
#		BattleData.PLAYER_SIDE_TAG : {
#			"name" : "",
#			"color" : {
#				"r": Color.blue.r,
#				"g": Color.blue.g,
#				"b": Color.blue.b,
#				"a": Color.blue.a
#			},
#			"squads": SquadData.SQUAD_LIST,
#			"troop_remain" : 0,
#			"troop_kill" : 0,
#			"troop_lost" : 0,
#			"position" : {
#				"x" : 0.0,
#				"y" : 0.0,
#			}
#		},
#		BattleData.BOT_SIDE_TAG : {
#			"name" : "",
#			"color" : {
#				"r": Color.red.r,
#				"g": Color.red.g,
#				"b": Color.red.b,
#				"a": Color.red.a
#			},
#			"squads": SquadData.SQUAD_LIST,
#			"troop_remain" : 0,
#			"troop_kill" : 0,
#			"troop_lost" : 0,
#			"position" : {
#				"x" : 0.0,
#				"y" : 0.0,
#			}
#		}
#	}
#}
