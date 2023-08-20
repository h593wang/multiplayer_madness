extends Control

@onready var room_list = $room_list
@onready var host_button = $host_button
@onready var join_button = $join_button
@onready var refresh_button = $refresh_button
@onready var host_local_button = $host_local_button
@onready var join_local_button = $join_local_button

@onready var room_list_request = $room_list_request
@onready var room_poll_request = $room_poll_request
@onready var host_request = $host_request
@onready var login_request = $login_request

var room_list_url = 'https://api.hathora.dev/lobby/v2/%s/list/public' % Globals.APP_ID
var room_host_url = 'https://api.hathora.dev/lobby/v2/%s/create' % Globals.APP_ID
var login_url = 'https://api.hathora.dev/auth/v1/%s/login/anonymous' % Globals.APP_ID
var room_poll_url = 'https://api.hathora.dev/rooms/v2/%s/connectioninfo/{roomId}' % Globals.APP_ID

var connect_room_id = null
var login_token = null
var room_poll_active = false

var server_joined = false

const server_scene = preload('res://server/server.tscn')
const client_scene = preload('res://client/client.tscn')
	
func select_room(room_id):
	connect_room_id = room_id
		
func connect_to_server(conn_details):
	Globals.server_host = conn_details['host']
	Globals.server_port = conn_details['port']
	Globals.room_id = connect_room_id
	
	var game_instance = client_scene.instantiate()
	game_instance.name = "GameInstance"
	get_tree().root.call_deferred("add_child", game_instance)
	get_parent().set_show_lobby(false)
	server_joined = true
	
func reload_rooms():
	room_list.clear()
	room_list_request.request(room_list_url)

func on_room_request_complete(_result, _response_code, _headers, body):
	var rooms = JSON.parse_string(body.get_string_from_utf8())
	if len(rooms) == 0:
		room_list.add_item('No rooms found.')
	else:
		for room in rooms:
			room_list.add_item(room['roomId'])
			
func on_host_request_complete(_result, _response_code, _headers, body):
	var response_body = JSON.parse_string(body.get_string_from_utf8())
	
	select_room(response_body['roomId'])	

func on_host_click():
	# Set a rudimentary loading state
	host_button.text = "Creating game..."
	host_button.disabled = true
	join_button.disabled = true
	# And fire off our request
	var headers = [
		'Content-Type: application/json',
		'Authorization: %s' % login_token 
	]
	var body = {
		'initialConfig': {},
		# For now, make all rooms public
		'visibility': 'public',
		# Midway between each coast?
		'region': 'Chicago',
	}
	host_request.request(room_host_url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

func on_login_request_complete(_result, _response_code, _headers, body):
	var response_body = JSON.parse_string(body.get_string_from_utf8())
	login_token = response_body['token']
	# We're logged in to Hathora. Enable our buttons.
	host_button.disabled = false
	join_button.disabled = false
	
func on_room_poll_request_complete(_result, _response_code, _headers, body):
	room_poll_active = false
	var response_body = JSON.parse_string(body.get_string_from_utf8())
	if response_body['status'] == 'active':
		var conn_details = response_body['exposedPort']
		# Add the websocket protocol
		conn_details['host'] = 'wss://' + conn_details['host']
		connect_to_server(conn_details)

func on_join_click():
	var selected_idxs = room_list.get_selected_items()
	if len(selected_idxs) == 0:
		# No room selected. Bye.
		return
		
	select_room(room_list.get_item_text(selected_idxs[0]))
	
	host_button.disabled = true
	join_button.disabled = true
	join_button.text = 'Joining game...'
	
func on_refresh_click():
	reload_rooms()

func on_host_local_click():
	Globals.is_local_server = true
	get_tree().root.call_deferred("add_child", server_scene.instantiate())
	queue_free()
	
func on_join_local_click():
	connect_to_server({
		"host": "ws://127.0.0.1",
		"port": Globals.MULTIPLAYER_PORT
	})
	
# Called when the node enters the scene tree for the first time.
func _ready():
	room_list_request.request_completed.connect(on_room_request_complete)
	host_request.request_completed.connect(on_host_request_complete)
	login_request.request_completed.connect(on_login_request_complete)
	room_poll_request.request_completed.connect(on_room_poll_request_complete)
	
	host_button.pressed.connect(on_host_click)
	join_button.pressed.connect(on_join_click)
	refresh_button.pressed.connect(on_refresh_click)
	host_local_button.pressed.connect(on_host_local_click)
	join_local_button.pressed.connect(on_join_local_click)
	
	login_request.request(login_url, [], HTTPClient.METHOD_POST)
	reload_rooms()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Continuously poll the hosted room, if we have one
	if connect_room_id != null and not room_poll_active and not server_joined:
		room_poll_active = true
		var url = room_poll_url.format({ 'roomId': connect_room_id })
		room_poll_request.request(url)
		
