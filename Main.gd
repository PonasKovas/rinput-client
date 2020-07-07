extends Control

func _process(_delta):
	if not Input.is_mouse_button_pressed(1):
		for child in get_children():
			if child.name != "JOYSTICK":
				child.pressed = -1
				child.texture = load("assets/"+child.name+".png")
	if Stream.stream.get_status() != 2:
		# oh shit lost connection
		get_tree().change_scene("res://Connect.tscn")

func _input(event):
	if event is InputEventScreenDrag:
		if event.index == $JOYSTICK.pressed:
			var vec = Vector2(
				event.position.x - $JOYSTICK.rect_global_position.x - 150,
				event.position.y - $JOYSTICK.rect_global_position.y - 150
			)
			var norm = vec.normalized()
			var length = vec.length()
			if length < 150:
				$JOYSTICK.get_child(0).rect_position.x = 102 + vec.x
				$JOYSTICK.get_child(0).rect_position.y = 102 + vec.y
				$JOYSTICK.direction = norm * length/150.0
			else:
				$JOYSTICK.get_child(0).rect_position.x = 102 + norm.x*150
				$JOYSTICK.get_child(0).rect_position.y = 102 + norm.y*150
				$JOYSTICK.direction = norm
		else:
			for child in get_children():
				if child.name == "JOYSTICK":
					continue
				if child.get_rect().has_point(event.position):
					if child.pressed == -1:
						child.pressed = event.index
						child.texture = load("assets/"+child.name+"_pressed.png")
				else:
					if child.pressed == event.index:
						child.pressed = -1
						child.texture = load("assets/"+child.name+".png")
	
	if event is InputEventScreenTouch:
		for child in get_children():
			if not event.pressed and child.pressed == event.index:
				child.pressed = -1
				if child.name == "JOYSTICK":
					child.direction = Vector2(0,0)
					child.texture = load("assets/joystick_bg.png")
					child.get_child(0).texture = load("assets/joystick.png")
				else:
					child.texture = load("assets/"+child.name+".png")
			if event.pressed and child.get_rect().has_point(event.position):
				if child.pressed == -1:
					child.pressed = event.index
					if child.name == "JOYSTICK":
						var vec = Vector2(
							event.position.x - $JOYSTICK.rect_global_position.x - 150,
							event.position.y - $JOYSTICK.rect_global_position.y - 150
						)
						var norm = vec.normalized()
						var length = vec.length()
						if length < 150:
							$JOYSTICK.get_child(0).rect_position.x = 102 + vec.x
							$JOYSTICK.get_child(0).rect_position.y = 102 + vec.y
							$JOYSTICK.direction = norm * length/150.0
						else:
							$JOYSTICK.get_child(0).rect_position.x = 102 + norm.x*150
							$JOYSTICK.get_child(0).rect_position.y = 102 + norm.y*150
							$JOYSTICK.direction = norm
						child.texture = load("assets/joystick_bg_pressed.png")
						child.get_child(0).texture = load("assets/joystick_pressed.png")
					else:
						child.texture = load("assets/"+child.name+"_pressed.png")
