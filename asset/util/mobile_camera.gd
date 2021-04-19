extends Camera2D

signal on_camera_moving(_pos,_zoom)

var min_zoom = 0.5
var max_zoom = 2.5
var zoom_sensitivity = 10
var zoom_speed = 0.05

var events = {}
var last_drag_distance = 0

func _process(delta):
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") 
 
	position += velocity * delta * 550
		
func _unhandled_input(event):
	if event.is_action("scroll_up"):
		if(zoom.x - zoom_speed>= min_zoom && zoom.y - zoom_speed >= min_zoom):
			zoom.x -= zoom_speed
			zoom.y -= zoom_speed

	elif event.is_action("scroll_down"):
		if(zoom.x + zoom_speed <= max_zoom && zoom.y + zoom_speed <= max_zoom):
			zoom.x += zoom_speed
			zoom.y += zoom_speed
	
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
			
		else:
			events.erase(event.index)

	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			position += (-event.relative) * zoom.x
			
		elif events.size() == 2:
			var drag_distance = events[0].position.distance_to(events[1].position)
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
				new_zoom = clamp(zoom.x * new_zoom, min_zoom, max_zoom)
				zoom = Vector2.ONE * new_zoom
				last_drag_distance = drag_distance
				
	emit_signal("on_camera_moving",position,zoom)
				
				
				
