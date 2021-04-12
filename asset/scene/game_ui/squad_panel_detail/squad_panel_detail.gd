extends PanelContainer

class_name SquadPanelDetail

const MAX_STATS = {
	"name" : "",
	"description" : "",
	"squad_icon" : "",
	"attack_damage" : 15.0,
	"hit_point" : 100.0,
	"armor" : 5.0,
	"range_attack" : 100.0,
	"attack_speed" : 5.0,
	"max_speed" : 200.0
}

onready var _squad_icon = $HBoxContainer/VBoxContainer/TextureRect
onready var _squad_name = $HBoxContainer/VBoxContainer2/Label
onready var _squad_description = $HBoxContainer/VBoxContainer2/Label2
onready var _squad_attack_bar = $HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress
onready var _squad_armor_bar = $HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress2
onready var _squad_hp_bar = $HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress3
onready var _squad_range_bar = $HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress4
onready var _squad_speed_bar= $HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress5

var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "",
	"attack_damage" : 15.0,
	"hit_point" : 100.0,
	"armor" : 5.0,
	"range_attack" : 100.0,
	"attack_speed" : 5.0,
	"max_speed" : 200.0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_squad_attack_bar.self_modulate = Color(Color.green)
	_squad_hp_bar.self_modulate = Color(Color.green)
	_squad_armor_bar.self_modulate = Color(Color.green)
	_squad_range_bar.self_modulate = Color(Color.green)
	_squad_speed_bar.self_modulate = Color(Color.green)

func show_stats(_data):
	data = _data
	_squad_name.text = data.name
	_squad_description.text = data.description + "\n\n"
	_squad_icon.texture = load(data.squad_icon)
	
	_squad_attack_bar.max_value = MAX_STATS.attack_damage
	_squad_hp_bar.max_value = MAX_STATS.hit_point 
	_squad_armor_bar.max_value = MAX_STATS.armor 
	_squad_range_bar.max_value = MAX_STATS.range_attack 
	_squad_speed_bar.max_value = MAX_STATS.max_speed
	
	_squad_attack_bar.value = data.attack_damage
	_squad_hp_bar.value = data.hit_point 
	_squad_armor_bar.value = data.armor 
	_squad_range_bar.value = data.range_attack 
	_squad_speed_bar.value = data.max_speed
 

func _on_squad_panel_detail_gui_input(event):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.is_pressed()):
		visible = false
