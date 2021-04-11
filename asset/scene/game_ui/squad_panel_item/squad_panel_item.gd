extends Control

signal on_squad_icon_click(squad)

onready var _selected_indicator = $TextureRect
onready var _texture_rect = $VBoxContainer/TextureRect
onready var _label = $VBoxContainer/Label

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
	if is_instance_valid(squad):
		_label.text = str(squad.data.troop_amount)
		squad.connect("on_squad_troop_dead",self,"_on_squad_troop_dead")

func _on_squad_troop_dead(troop_left):
	_label.text = str(troop_left)

func _on_squad_panel_icon_gui_input(event):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.is_pressed()):
		emit_signal("on_squad_icon_click", squad)
		is_selected = !is_selected
		_selected_indicator.visible = is_selected
		squad.set_selected(is_selected)
