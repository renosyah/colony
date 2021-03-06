extends Control

signal on_squad_icon_click(squad)

onready var _selected_indicator = $TextureRect
onready var _texture_rect = $VBoxContainer/TextureRect
onready var _squad_scatter = $TextureRect3
onready var _label = $VBoxContainer/Label
onready var _flicker_timer = $flicker_time
onready var _flicker = $TextureRect2
onready var _audio = $AudioStreamPlayer2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_selected = false

var squad = null
var data = {
	"name" : "",
	"description" : "",
	"squad_icon" : "res://asset/ui/icons/squad_icon/icon_empty.png",
	"troop_amount" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_texture_rect.texture = load(data.squad_icon)
	_squad_scatter.visible = false
	if is_instance_valid(squad):
		_label.text = str(squad.data.troop_amount)
		squad.connect("on_squad_click",self,"_on_squad_click")
		squad.connect("on_squad_scatter",self,"_on_squad_scatter")
		squad.connect("on_squad_troop_dead",self,"_on_squad_troop_dead")

func _on_squad_troop_dead(troop_left):
	_label.text = str(troop_left)
	_flicker.visible = true
	_flicker_timer.start()
	
func _on_squad_panel_icon_pressed():
	_on_squad_click(squad)
 
func _on_squad_click(_squad):
	emit_signal("on_squad_icon_click", _squad)
	is_selected = !is_selected
	_selected_indicator.visible = is_selected
	_squad.set_selected(is_selected)
	_audio.stream = preload("res://asset/sound/click.wav")
	_audio.play()

func _on_squad_scatter(is_scatter):
	_squad_scatter.visible = is_scatter

func select_current_squad(_is_select):
	is_selected = _is_select
	_selected_indicator.visible = is_selected
	squad.set_selected(is_selected)
	
func _on_flicker_time_timeout():
	_flicker.visible = false
