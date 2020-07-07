extends TextureRect


var pressed = -1
var old_pressed = -1

func _process(_delta):
	if pressed != old_pressed:
		var byte = get_index()
		# if released add a minus
		if pressed == -1:
			byte *= -1
		Stream.stream.put_8(byte)
		
		old_pressed = pressed
