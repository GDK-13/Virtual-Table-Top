extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_M and $".".visible == true:
			$".".visible = false
		elif event.keycode == KEY_M and $".".visible == false:
			$".".visible = true


@export var inventory_item_scene: PackedScene

var _target_type: String = "" 
var _target_grid: Container = null

@onready var file_selector = $FileSelector

func _ready():
	file_selector.file_selected.connect(_on_file_selected)


func _on_importar_mapa_pressed() -> void:
	_abrir_seletor("map", %Mapas)

func _on_importar_token_pressed() -> void:
	_abrir_seletor("token", %Tokens)

func _on_importar_criatura_pressed() -> void:
	_abrir_seletor("creature", %Criaturas)

func _on_importar_misc_pressed() -> void:
	_abrir_seletor("misc", %Misc)


func _abrir_seletor(tipo: String, grid_destino: Container):
	_target_type = tipo
	_target_grid = grid_destino
	file_selector.show()

func _on_file_selected(path: String):
	if path.is_empty():
		return
		
	print("Importando: ", path)
	create_item_from_external_image(path)

func create_item_from_external_image(path: String):
	var image = Image.load_from_file(path)
	
	if image == null:
		print("Erro ao carregar imagem!")
		return
		
	var texture = ImageTexture.create_from_image(image)
	
	var new_item = inventory_item_scene.instantiate()
	
	new_item.item_type = _target_type
	new_item.item_texture = texture
	
	_target_grid.add_child(new_item)
