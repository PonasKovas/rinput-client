extends Button

func _ready():
	rect_min_size.x = get_node("../..").rect_size.x
