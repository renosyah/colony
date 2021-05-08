extends Node
class_name BotSetting


const EASY_SETTING = {
	"maximum_squad_control" : 3,
	"min_tinker_time" : 5,
	"max_tinker_time" : 20,
	"surrender_chance" : 0.4,
}
const MEDIUM_SETTING = {
	"maximum_squad_control" : 4,
	"min_tinker_time" : 5,
	"max_tinker_time" : 15,
	"surrender_chance" : 0.2,
}
const HARD_SETTING = {
	"maximum_squad_control" : 5,
	"min_tinker_time" : 5,
	"max_tinker_time" : 10,
	"surrender_chance" : 0.1,
}

const BOTS = [
	{
		"name" : "Bot : Easy",
		"setting" : EASY_SETTING,
	},
	{
		"name" : "Bot : Medium",
		"setting" : MEDIUM_SETTING,
	},
	{
		"name" : "Bot : Hard",
		"setting" : HARD_SETTING,
	}
]
