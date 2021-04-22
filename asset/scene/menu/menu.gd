extends Control

onready var _terrain = $terrain
onready var _quick_battle_button = $CanvasLayer/HBoxContainer/menu_panel/VBoxContainer/quick_battle
onready var _title_panel = $CanvasLayer/HBoxContainer/title_panel

func _ready():
	get_tree().set_quit_on_go_back(false)
	_terrain.generate_battlefield()
	_terrain.spawn_enviroment()
	
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST || what == NOTIFICATION_WM_GO_BACK_REQUEST):
		_on_quit_pressed()
		
func _on_quick_battle_pressed():
	get_tree().change_scene("res://asset/scene/menu/quick_battle_menu/quick_battle_menu.tscn")
	
func _on_quit_pressed():
	get_tree().quit()



