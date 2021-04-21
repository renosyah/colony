extends Node
class_name BattleData

const file_name = "user://battle_data.json"

const PLAYER_SIDE_TAG = "PLAYER"
const BOT_SIDE_TAG = "BOT"

const TYPE_QUICK_BATTLE = "TYPE_QUICK_BATTLE"

var battle_data = {
	"type" : TYPE_QUICK_BATTLE,
	"name" : "",
	"bot_setting" : {},
	"biom" : 0,
	"winner" : "",
	"battle" : {
		PLAYER_SIDE_TAG : {
			"name" : "",
			"color" : Color(Color.white),
			"squads": [],
			"position" : Vector2.ZERO
		},
		BOT_SIDE_TAG : {
			"name" : "",
			"color" : Color(Color.white),
			"squads": [],
			"position" : Vector2.ZERO
		}
	},
	"post_battle" : {
		PLAYER_SIDE_TAG : {
			"name" : "",
			"color" : Color(Color.white),
			"squads": [],
			"position" : Vector2.ZERO
		},
		BOT_SIDE_TAG : {
			"name" : "",
			"color" : Color(Color.white),
			"squads": [],
			"position" : Vector2.ZERO
		}
	}
}

func save_battle(_data):
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_var(_data, true)
	file.close()

func load_battle():
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		var _data = file.get_var(true)
		file.close()
		return _data
	return null

func delete():
	var dir = Directory.new()
	dir.remove(file_name)
		
		
		
		
