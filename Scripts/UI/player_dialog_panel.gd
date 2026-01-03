extends Control

@export var BtnJoinPath: String
@export var BtnQuitPath: String

@export var porta: int
@export var ip: String

func _on_btn_enter_pressed() -> void:
	ip = %IpLine.text
	porta = %PortaLine.text.to_int()
	var nome = %NameLine.text
	NetworkManager.join_game(ip, porta, nome)
	GameManagerClass.change_scene(BtnJoinPath)


func _on_btn_quit_pressed() -> void:
	GameManagerClass.change_scene(BtnQuitPath)
