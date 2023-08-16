extends Node

const MULTIPLAYER_PORT = 22222
const APP_ID = 'app-2fbbeb0b-0e85-4ee3-ad3e-9320f0980d1b'

var server_host = null
var server_port = null
var room_id = null

enum StartupMode { Client, Server }
	
var STARTUP_MODE = null	

func was_started_with_server():
	return '--server' in OS.get_cmdline_user_args()
	
func get_startup_mode():
	# Cache this so we don't read the cmd-line args every time.
	if STARTUP_MODE == null:
		if was_started_with_server():
			STARTUP_MODE = StartupMode.Server
		else:
			STARTUP_MODE = StartupMode.Client

	return STARTUP_MODE
		
func is_server():
	return get_startup_mode() == StartupMode.Server

func is_client():
	return get_startup_mode() == StartupMode.Client
	
