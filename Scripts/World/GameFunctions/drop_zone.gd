
extends Control


@export var map_node: TextureRect 

@export var token_scene: PackedScene 

@export var world_container: Node2D

const TOKEN_SIZE = Vector2(100, 100)

func _can_drop_data(_at_position, data):
	print("Detectou algo! Dados: ", data) 
	return typeof(data) == TYPE_DICTIONARY and data.has("type")


func _drop_data(_at_position, data):
	var world_layer = get_tree().get_first_node_in_group("WorldLayer")
	var camera = get_viewport().get_camera_2d()
	
	if not world_layer: return

	match data["type"]:
		"token", "criatura", "misc", "creature", "item":
			if token_scene:
				var new_token = token_scene.instantiate()
				world_layer.add_child(new_token)
				
				if camera:
					new_token.global_position = camera.get_global_mouse_position()
				else:
					new_token.global_position = world_layer.get_global_mouse_position()
				
				if "texture" in data:
					var tex = data["texture"]
					var sprite = null
					

					if new_token.has_node("Sprite2D"):
						sprite = new_token.get_node("Sprite2D")
						sprite.texture = tex
					elif new_token is Sprite2D:
						sprite = new_token
						sprite.texture = tex

					if sprite:
						var original_size = tex.get_size()

						var max_side = max(original_size.x, original_size.y)
						var scale_factor = TOKEN_SIZE.x / max_side

						new_token.scale = Vector2(scale_factor, scale_factor)

		"map":
			var _map_node = world_layer.get_node_or_null("MapRect")
			if map_node:
				map_node.texture = data["texture"]
				print("Mapa alterado!")
				
		_:
			print("Tipo desconhecido recebido: ", data["type"])

func create_token_in_world(texture: Texture2D):
	if not token_scene:
		print("ERRO: Nenhuma cena de Token configurada no DropZone!")
		return
		
	var new_token = token_scene.instantiate()
	
	var world = get_parent() 
	world.add_child(new_token)
	
	new_token.global_position = get_global_mouse_position()
	
	if new_token.has_method("set_texture"):
		new_token.set_texture(texture)
	else:
		var sprite = new_token.get_node_or_null("Sprite2D")
		if sprite:
			sprite.texture = texture
