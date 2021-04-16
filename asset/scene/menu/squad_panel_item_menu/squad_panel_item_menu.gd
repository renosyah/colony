extends Button

signal on_squad_icon_click(data)

onready var _texture_rect = $VBoxContainer/TextureRect
onready var _label = $VBoxContainer/Label
onready var _selected_indicator = $TextureRect

var clickable = true

var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_squad_empty.png",
	"banner_sprite" : "",
	"troop_amount" : 0,
	"formation_space" : 0,
	"side" : "",
	"color" : {
		"r": 0.0,
		"g": 0.0,
		"b": 0.0,
		"a": 0.0
	},
	"max_speed" : 0,
	"attack_delay" : 0,
	"troop_data" : {}
}
 
func _ready():
	_texture_rect.texture = load(data.squad_icon)
	_label.text = str(data.troop_amount)
	
func _on_squad_click():
	emit_signal("on_squad_icon_click", data)


func _on_squad_panel_icon_pressed():
	if !clickable:
		return
		
	_on_squad_click()
