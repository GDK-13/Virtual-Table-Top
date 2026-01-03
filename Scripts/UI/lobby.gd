extends Control

@onready var item_list = %PlayerList
@export var BackButtonPath: String

func _ready() -> void:
	if NetworkManager.has_signal("player_list_changed"):
		NetworkManager.player_list_changed.connect(_update_player_list)
	
	_update_player_list()
	
	if multiplayer.is_server():
		%IniMsg.visible = false
		%CampaignSelector.visible = true
		%Start.visible = true
	else:
		%IniMsg.visible = true
		%CampaignSelector.visible = false
		%Start.visible = false

func _on_back_pressed() -> void:
		multiplayer.multiplayer_peer = null
		NetworkManager.players.clear()
		GameManagerClass.change_scene(BackButtonPath)

func _update_player_list():
	if item_list != null:
		item_list.clear()
		
		for id in NetworkManager.players:
			var nome_player = NetworkManager.players[id]
			var index = item_list.add_item(nome_player)
			
			if id == 1:
				item_list.set_item_text(index, nome_player + " (Mestre)")
				item_list.set_item_custom_fg_color(index, Color.GOLD)


@rpc("any_peer", "call_local", "reliable")
func client_to_authority(chat_message: String):
	var id = multiplayer.get_remote_sender_id()
	var nome = NetworkManager.players.get(id, "Desconhecido")
	
	var cor = "white"
	if id == 1:
		cor = "gold"
	var msg_final = "[color=%s]%s:[/color] %s" % [cor, nome, chat_message]
	
	authority_to_client.rpc(msg_final)

func _on_input_line_text_submitted(_new_text: String) -> void:
	_on_send_button_pressed()


func _on_send_button_pressed() -> void:
	var mensagem = %InputLine.text.strip_edges()
	
	if mensagem.is_empty():
		return
		
	client_to_authority.rpc_id(1, mensagem)
	
	%InputLine.text = ""


@rpc("authority", "call_local", "reliable")
func authority_to_client(chat_message: String):
	%ChatLog.append_text(chat_message + "\n") 
	%ChatLog.scroll_to_line(%ChatLog.get_line_count() - 1)


	await get_tree().process_frame 
	if %ChatLog.get_parent() is ScrollContainer:
		var scroll = %ChatLog.get_parent()
		scroll.set_v_scroll(scroll.get_v_scroll_bar().max_value)
