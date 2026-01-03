@tool
extends TextureRect

@export_enum("map", "token", "creature", "misc") var item_type: String = "token"

@export var item_texture: Texture2D:
	set(value):
		item_texture = value
		texture = value 


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(64, 64)
	preview.modulate.a = 0.7
	
	var preview_control = Control.new()
	preview_control.add_child(preview)
	preview.position = -0.5 * preview.custom_minimum_size
	set_drag_preview(preview_control)
	
	return {
		"type": item_type,
		"texture": texture,
		"origin": self
	}
