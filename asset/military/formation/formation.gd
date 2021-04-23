extends Node
class_name Formation

const FORMATION_BOX_BONUS = {
	"attack" : 0.0,
	"defence" : 0.0,
	"mobility" : 0.0,
	"attack_delay" : 0.0
}
const FORMATION_DELTA_BONUS = {
	"attack" : 2.0,
	"defence" : -2.0,
	"mobility" : 25.0,
	"attack_delay" : -0.5
}
const FORMATION_CIRCLE_BONUS = {
	"attack" : -2.0,
	"defence" : 2.0,
	"mobility" : -10.0,
	"attack_delay": 0.5
}

const FORMATION_BOX_CHATTER = [
	"Standard formation, lads!!",
	"Back in the line!!",
	"Make ready, lads!!"
]
const FORMATION_DELTA_CHATTER = [
	"Attack formation!!",
	"Make some room!!",
	"Spread out, lads!!"
]
const FORMATION_CIRCLE_CHATTER = [
	"Defensive formation!!",
	"Stick together, lads!!",
	"Hold the line!!"
]


const FORMATION_SCATTER_CHATTER = [
	"Fall back!!",
	"Save your self, lads!!",
	"Break.. break!!",
	"Run for your life!!",
	"This is too much!!",
	"Ruun!!"
]

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
