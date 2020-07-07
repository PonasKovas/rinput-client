extends TextureRect


var pressed = -1
var direction = Vector2(0,0)
var old_direction = Vector2(0,0)

func _process(_delta):
	if direction != old_direction:
		Stream.stream.put_8(0)
		
		var x = int(round(direction.x*32767.0))
		var y = int(round(direction.y*32767.0))
		
		Stream.stream.put_16(x)
		Stream.stream.put_16(y)
		
		old_direction = direction
