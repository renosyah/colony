extends PanelContainer
class_name SquadPanelDetailMenu

signal on_squad_icon_click(data)

onready var _squad_icon = $VBoxContainer/HBoxContainer/VBoxContainer/TextureRect
onready var _squad_name = $VBoxContainer/HBoxContainer/VBoxContainer2/Label
onready var _squad_description = $VBoxContainer/HBoxContainer/VBoxContainer2/Label2
onready var _squad_attack_bar = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress
onready var _squad_armor_bar = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress2
onready var _squad_hp_bar = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress3
onready var _squad_range_bar = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress4
onready var _squad_speed_bar= $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress5
onready var _squad_morale_bar = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/TextureProgress6

var clickable = true

var squad_data = {}
var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "",
	"attack_damage" : 15.0,
	"hit_point" : 100.0,
	"armor" : 5.0,
	"range_attack" : 100.0,
	"max_speed" : 200.0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_squad_name.text = data.name
	_squad_description.text = data.description + "\n\n"
	_squad_icon.texture = load(data.squad_icon)
	
	_squad_attack_bar.max_value = TroopData.MAX_STATS.attack_damage
	_squad_hp_bar.max_value = TroopData.MAX_STATS.hit_point 
	_squad_armor_bar.max_value = TroopData.MAX_STATS.armor 
	_squad_range_bar.max_value = TroopData.MAX_STATS.range_attack 
	_squad_speed_bar.max_value = TroopData.MAX_STATS.max_speed
	_squad_morale_bar.max_value = TroopData.MAX_STATS.morale_point
	
	_squad_attack_bar.value = data.attack_damage
	_squad_hp_bar.value = data.hit_point 
	_squad_armor_bar.value = data.armor 
	_squad_range_bar.value = data.range_attack 
	_squad_speed_bar.value = data.max_speed
	_squad_morale_bar.value = data.morale_point

func show_stats(squad):
	
	squad_data = squad
	
	var template = TroopData.MAX_STATS.duplicate()
	template.name = squad.name
	template.description = squad.description
	template.squad_icon = squad.squad_icon
	template.attack_damage = squad.troop_data.attack_damage
	template.hit_point = squad.troop_data.hit_point
	template.armor = squad.troop_data.armor
	template.range_attack = squad.troop_data.range_attack
	template.max_speed = squad.troop_data.max_speed
	template.morale_point = squad.morale_point
	
	data = template
 

func _on_Button_pressed():
	if !clickable:
		return
	emit_signal("on_squad_icon_click", squad_data)
