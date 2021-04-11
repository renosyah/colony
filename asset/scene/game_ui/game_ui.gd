extends Node2D

onready var _squad_panel = $CanvasLayer/VBoxContainer/HBoxContainer2/ScrollContainer/HBoxContainer

var _squad_in_command = []
var _selected_squad = []

var _amount_food = 0
var _amount_wood = 0
var _amount_ore = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Control_gui_input(event):
	
	get_viewport().unhandled_input(event)
	
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.is_pressed():
		var click_pos = get_canvas_transform().affine_inverse().xform(event.position)
		click_pos.y += 100.0
		move_all_selected_squad(click_pos)
 
func move_all_selected_squad(pos):
	for squad in _selected_squad:
		squad.is_move = true
		squad.waypoint = pos

func _on_squad_on_squad_ready(squad):
	_squad_in_command.append(squad)
	add_squad_to_squad_panel(squad)
	
func _on_squad_on_squad_dead(squad):
	_squad_in_command.erase(squad)
	_selected_squad.erase(squad)
	remove_squad_from_squad_panel(squad)

func add_squad_to_squad_panel(squad):
	var squad_panel_item = preload("res://asset/scene/game_ui/squad_panel_item/squad_panel_item.tscn").instance()
	squad_panel_item.data.name = squad.data.name
	squad_panel_item.data.description = squad.data.description
	squad_panel_item.data.squad_icon = squad.data.squad_icon
	squad_panel_item.data.troop_amount = squad.data.troop_amount
	squad_panel_item.squad = squad
	squad_panel_item.connect("on_squad_icon_click",self,"_on_squad_icon_click")
	_squad_panel.add_child(squad_panel_item)
	
func remove_squad_from_squad_panel(squad):
	for child in _squad_panel.get_children():
		if child.squad == squad:
			_squad_panel.remove_child(child)
		
func _on_squad_icon_click(squad):
	if _selected_squad.has(squad):
		_selected_squad.erase(squad)
	else:
		_selected_squad.append(squad)

func _on_resource_collected(type, amount):
	match type:
		Resources.RESOURCES_TYPE_FOOD:
			_amount_food += amount
			$CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer/Label.text = kFormatter(_amount_food)
		Resources.RESOURCES_TYPE_WOOD:
			_amount_wood += amount
			$CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer2/Label2.text = kFormatter(_amount_wood)
		Resources.RESOURCES_TYPE_MINERAL:
			_amount_ore += amount
			$CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer3/Label3.text = kFormatter(_amount_ore)

func kFormatter(num):
	if abs(num) > 999:
		return str(sign(num) * stepify((abs(num)/1000),1)) + 'k'
	else:
		return str(sign(num)*abs(num))



