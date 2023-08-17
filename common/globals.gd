extends Node

const MULTIPLAYER_PORT = 22222
const APP_ID = 'app-2fbbeb0b-0e85-4ee3-ad3e-9320f0980d1b'

var server_host = null
var server_port = null
var room_id = null
var client_peer_id = null

enum StartupMode { Client, Server }
	
var STARTUP_MODE = null	
var is_local_server = false

var was_started_as_server = '--server' in OS.get_cmdline_user_args()

var enemies_killed = 0
var current_player_health = 3

func get_startup_mode():
	if was_started_as_server || is_local_server:
		return StartupMode.Server
	else:
		return StartupMode.Client
		
func is_server():
	return get_startup_mode() == StartupMode.Server

func is_client():
	return get_startup_mode() == StartupMode.Client
	
func is_client_controlled(peer_id):
	return client_peer_id == peer_id
