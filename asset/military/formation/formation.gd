extends Node
class_name Formation

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FORMATION_BOX_BONUS = {
	"attack_damage" : 1.0,
	"armor" : 1.0,
}
const FORMATION_DELTA_BONUS = {
	"attack_damage" : 2.0,
	"armor" : -2.0,
}
const FORMATION_CIRCLE_BONUS = {
	"attack_damage" : -2.0,
	"armor" : 2.0,
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_formation_box(waypoint_position :Vector2 ,number_of_unit : int, space_between_units : int = 20):
	var formations = []
	var square_side_size = round(sqrt(number_of_unit))
	var unit_pos = waypoint_position - space_between_units * Vector2(square_side_size/2,square_side_size/2)
	for i in number_of_unit:
		formations.append({
			"position": unit_pos
		})
		unit_pos.x += space_between_units
		if unit_pos.x > (waypoint_position.x + square_side_size * space_between_units / 2):
			unit_pos.y += space_between_units
			unit_pos.x = waypoint_position.x - space_between_units * square_side_size / 2
	return formations
	
func get_formation_delta(waypoint_position :Vector2 ,number_of_unit : int, space_between_units : int = 20):
	var formations = []
	var triangle_base_size = round(sqrt(2*number_of_unit))
	var unit_pos = waypoint_position - space_between_units * Vector2(0,triangle_base_size/2)
	var unit_count_in_line = 0
	var unit_total_in_line = 1
	for x in number_of_unit:
		formations.append({
			"position": unit_pos
		})
		unit_pos.x += space_between_units
		unit_count_in_line += 1
		if unit_count_in_line >= unit_total_in_line:
			unit_count_in_line = 0
			unit_total_in_line += 1
			unit_pos.y += space_between_units
			unit_pos.x = waypoint_position.x - space_between_units * (unit_total_in_line-1)/2
			
	return formations
	
func get_formation_circle(waypoint_position :Vector2 ,number_of_unit : int, space_between_units : int = 20):
	var formations = []
	var unit_pos = waypoint_position
	var circle_size = 0
	var unit_total_count_in_circle = 6 * circle_size
	var unit_count_in_circle = 0
	var current_angle = 0
	for x in number_of_unit:
		formations.append({
			"position": unit_pos
		})
		unit_count_in_circle += 1
		if unit_count_in_circle >= unit_total_count_in_circle:
			unit_count_in_circle = 0
			current_angle = 0
			circle_size += 1
			unit_total_count_in_circle = 6 * circle_size
			unit_pos.x = waypoint_position.x + space_between_units * circle_size
			unit_pos.y = waypoint_position.y
		else:
			current_angle += (PI/3) / circle_size
			unit_pos.x = waypoint_position.x + (space_between_units * circle_size) * cos(current_angle)
			unit_pos.y = waypoint_position.y + (space_between_units * circle_size) * sin(current_angle)
			
	return formations
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
