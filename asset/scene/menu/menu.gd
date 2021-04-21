extends Control

onready var _terrain = $terrain

onready var _campaign_button = $CanvasLayer/HBoxContainer/menu_panel/VBoxContainer/campaign
onready var _quick_battle_button = $CanvasLayer/HBoxContainer/menu_panel/VBoxContainer/quick_battle
onready var _about_button = $CanvasLayer/HBoxContainer/menu_panel/VBoxContainer/about
onready var _quit_button = $CanvasLayer/HBoxContainer/menu_panel/VBoxContainer/quit

onready var _about_panel = $CanvasLayer/HBoxContainer/about_panel
onready var _title_panel = $CanvasLayer/HBoxContainer/title_panel

func _ready():
	_terrain.generate_battlefield()
	_terrain.spawn_enviroment()

func _on_quick_battle_pressed():
	get_tree().change_scene("res://asset/scene/menu/quick_battle_menu/quick_battle_menu.tscn")
	
func _on_about_pressed():
	_title_panel.visible = _about_panel.visible
	_about_panel.visible = !_title_panel.visible

func _on_quit_pressed():
	get_tree().quit()



