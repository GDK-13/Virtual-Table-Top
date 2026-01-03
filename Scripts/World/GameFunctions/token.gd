extends CharacterBody2D

func set_texture(tex: Texture2D):
	$Sprite2D.texture = tex
	

	var tamanho_padrao = Vector2(64, 64)
	var escala = tamanho_padrao / tex.get_size()
	scale = escala
