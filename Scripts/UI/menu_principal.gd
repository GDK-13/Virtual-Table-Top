extends Control

@export var JoinButtonPath: String
@export var HostButtonPath: String

var titulo
var desc

func _ready():
	pass

func _on_btn_join_pressed() -> void:
	GameManagerClass.change_scene(JoinButtonPath)

func _on_btn_host_pressed() -> void:
	GameManagerClass.change_scene(HostButtonPath)

func _on_btn_quit_pressed() -> void:
	get_tree().quit()

func _on_btn_camp_pressed() -> void:
	%CampWin.visible = true

func _on_btn_criar_pressed() -> void:
	titulo = %NomeLine.text
	desc = %DescLine.text
	
	if titulo.is_empty():
		print("O nome não pode ser vazio!")
		return
	GlobalGameManager.create_new_campaign(titulo, desc)

	%CampWin.visible = false
	%NomeLine.text = ""
	%DescLine.text = ""
