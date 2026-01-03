extends Control

@export var BtnCreatePath: String
@export var BtnQuitPath: String

@export var porta: int
@export var Max_Players: int

func _on_btn_create_pressed() -> void:
	porta = %PortaLine.text.to_int()
	Max_Players = %MpLine.text.to_int()
	var nome = %NameLine.text
	NetworkManager.create_host(porta, Max_Players, nome)
	GameManagerClass.change_scene(BtnCreatePath)
	

func _on_btn_quit_pressed() -> void:
	GameManagerClass.change_scene(BtnQuitPath)
