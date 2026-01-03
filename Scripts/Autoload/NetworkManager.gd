extends Node

signal player_list_changed
signal connection_success
signal connection_failed

var players = {}
var local_player_name = ""

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connection_success)
	multiplayer.connection_failed.connect(_on_connection_failed)

func create_host(porta: int, maxplayers: int, playername: String):
	local_player_name = playername
	var peer = ENetMultiplayerPeer.new()    
	var error = peer.create_server(porta, maxplayers)
	
	if error != OK:
		print("Erro ao criar servidor: ", error)
		return false
	
	multiplayer.multiplayer_peer = peer
	
	register_player(1, local_player_name) 
	return true


func join_game(ip_adress: String, porta: int, playername: String):
	local_player_name = playername
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip_adress, porta)

	if error != OK:
		print("Erro ao criar cliente: ", error)
		return
		
	multiplayer.multiplayer_peer = peer


@rpc("any_peer", "call_local", "reliable")
func register_player(id, p_name):
	players[id] = p_name
	player_list_changed.emit()
	
	if multiplayer.is_server() and id != 1:
		for p_id in players:
			if p_id != id:
				register_player.rpc_id(id, p_id, players[p_id])



func _on_connection_success():
	print("Conectado com sucesso! Enviando informações...")
	register_player.rpc(multiplayer.get_unique_id(), local_player_name)
	connection_success.emit()

func _on_connection_failed():
	print("Falha na conexão")
	connection_failed.emit()


func _on_player_connected(id):
	print("Nova conexão detectada (nível de rede): ", id)


func _on_player_disconnected(id):
	players.erase(id)
	player_list_changed.emit()
