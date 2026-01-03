extends Node
class_name GameManagerClass

@export var current_scene: Node
static var _instance: Node = null

func _ready() -> void:
	if _instance == null:
		_instance = self

static func change_scene(path: String) -> void:
	if _instance:
		_instance.get_tree().change_scene_to_file(path)


#============================ Data Persistance ============================

#=========== Campanha ===========

var current_campaign_name: String = ""

func set_value(campaign_file_name: String, key: String, value: Variant):

	var save = Data.new_data_dict(campaign_file_name)

	if save == null:
		printerr("ERRO CRÍTICO: Não foi possível criar/carregar o save: ", campaign_file_name)
		return

	if save.exists(key):
		save.update(key, value)
	else:
		save.add(key, value)

	save.save()

func get_value(campaign_file_name: String, key: String, default_value: Variant = null) -> Variant:
	var save = Data.new_data_dict(campaign_file_name)

	if save == null:
		return default_value

	if save.exists(key):
		return save.fields[key].value
	return default_value

func create_new_campaign(title: String, description: String) -> bool:
	var file_id = title.to_lower().replace(" ", "_")
	
	var check_save = Data.new_data_dict(file_id)
	if check_save.exists("title"):
		print("Erro: Já existe uma campanha com esse ID.")
		return false
	
	set_value(file_id, "title", title)
	set_value(file_id, "description", description)
	set_value(file_id, "creation_date", Time.get_datetime_string_from_system())
	
	print("Campanha criada: ", file_id)
	return true

func get_all_campaigns() -> Array:
	var list = []
	var dir_path = "user://Data/"
	var dir = DirAccess.open(dir_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".txt"):
				var file_id = file_name.replace(".txt", "")
				var title = get_value(file_id, "title", "Sem Título")
				
				list.append({
					"id": file_id,
					"title": title
				})
				
			file_name = dir.get_next()
			
	return list
