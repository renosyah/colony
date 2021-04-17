extends Node
class_name BotSetting



const EASY_SETTING = {
	"maximum_squad_control" : 1,
	"maximum_squad_target" : 5,
	"min_tinker_time" : 10,
	"max_tinker_time" : 20
}
const MEDIUM_SETTING = {
	"maximum_squad_control" : 2,
	"maximum_squad_target" : 2,
	"min_tinker_time" : 10,
	"max_tinker_time" : 30
}
const HARD_SETTING = {
	"maximum_squad_control" : 5,
	"maximum_squad_target" : 1,
	"min_tinker_time" : 5,
	"max_tinker_time" : 10
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
