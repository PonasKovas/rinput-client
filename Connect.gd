extends Control

var socket = PacketPeerUDP.new()

var known_hosts = []

func _ready():
	if socket.listen(44554) != OK:
		print("Error listening on port 44554")
		error("Error binding the UDP listener to port 44554")

func _process(_delta):
	if socket.get_available_packet_count() > 0:
		var ip = socket.get_packet_ip()
		var bytes = socket.get_packet()
		
		if ip == "":
			return
		
		var hostname_len = bytes[0] | bytes[1] << 8 | bytes[2] << 16 | bytes[3] << 24
		var hostname = bytes.subarray(4,3+hostname_len).get_string_from_utf8()
		var port = bytes[4+hostname_len] | bytes[5+hostname_len] << 8
		
		if known_hosts.has([ip, port]):
			return
		
		known_hosts.append([ip, port])
		var button = preload("res://Host.tscn")
		var button_instance = button.instance()
		button_instance.text = hostname + " " + ip + ":" + str(port)
		button_instance.connect("button_up", self, "connect_to_host", [ip, port])
		$ScrollContainer/VBoxContainer.add_child(button_instance)

func connect_to_host(ip, port):
	Stream.stream.disconnect_from_host()
	
	# try connecting
	if Stream.stream.connect_to_host(ip, port) != OK:
		error("failed connecting")
		return
	
	Stream.stream.set_no_delay(true)
	
	# wait for connection
	while true:
		if Stream.stream.get_status() > 1:
			break
	
	# auth
	var password = $Password.text
	Stream.stream.put_u8(password.length())
	Stream.stream.put_data(password.to_utf8())
	
	Stream.stream.get_u8()
	
	if not Stream.stream.is_connected_to_host():
		error("auth unsuccessful")
		return
	
	# everything good bro change scene
	# change scene
	get_tree().change_scene("res://Main.tscn")

func _on_Button_button_down():
	Stream.stream.disconnect_from_host()
	
	var address = $LineEdit.text
	if address == "":
		error("Enter an address")
		return
	
	if address.split(":").size() != 2:
		error("enter a valid IP address")
		return
	
	# try connecting
	if Stream.stream.connect_to_host(address.split(":")[0], int(address.split(":")[1])) != OK:
		error("failed connecting")
		return
	
	Stream.stream.set_no_delay(true)
	
	while true:
		if Stream.stream.get_status() > 1:
			break
	
	# connected successfully
	# auth
	var password = $LineEdit2.text
	Stream.stream.put_u8(password.length())
	Stream.stream.put_data(password.to_utf8())
	
	Stream.stream.get_u8()
	
	if not Stream.stream.is_connected_to_host():
		error("auth unsuccessful")
		return
	
	# change scene
	# Remove the current level
	get_tree().change_scene("res://Main.tscn")

func error(text):
	$Errors.text = text
