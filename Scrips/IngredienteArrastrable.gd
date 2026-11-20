extends TextureButton

@export var id_item: String = "azucar" # Cambiar en el Inspector: "mora", "azucar", "agua", "frasco", "tomate", "aceite"
@export var icono_arrastre: Texture2D # Opcional: si querés que al arrastrar se vea solo la fruta sin el marco

func _get_drag_data(_at_position: Vector2) -> Variant:
	var textura_a_usar = icono_arrastre if icono_arrastre != null else texture_normal
	
	# 1. Creamos la imagen temporal que sigue el dedo/mouse
	var preview = TextureRect.new()
	preview.texture = textura_a_usar
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = Vector2(90, 90)
	
	# Centramos el ícono en el dedo/cursor
	var contenedor_preview = Control.new()
	contenedor_preview.add_child(preview)
	preview.position = -preview.custom_minimum_size / 2
	set_drag_preview(contenedor_preview)
	
	# 2. Devolvemos los datos del objeto que estamos arrastrando
	return {
		"tipo": "frasco" if id_item == "frasco" else "ingrediente",
		"id": id_item,
		"textura": textura_a_usar
	}
