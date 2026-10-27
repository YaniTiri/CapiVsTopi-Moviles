extends CanvasLayer

@onready var label_monedas: Label = $Sprite2D/Label

@onready var boton_repisa: Button = $Item_Repisa/Boton_repisa
@onready var boton_sillon: Button = $Item_Sillon/Boton_sillon
@onready var boton_libros: Button = $Item_Libros/Boton_libros
@onready var boton_maceta: Button = $Item_Maceta/Boton_Maceta
@onready var boton_chimenea: Button = $Item_Adorno_Chimenea/Boton_adornochimenea
@onready var boton_mesa: Button = $Item_Mesa1/Boton_mesa1

# Referencia al botón de cerrar
@onready var boton_cerrar: Button = $Cerrar


func _ready() -> void:
	# Monedas de prueba
	GameManager.monedas = 300
	
	# Aplicamos el estilo "cute" a todos los botones desde código
	aplicar_estilo_cute_a_botones()
	
	actualizar_interfaz()


func aplicar_estilo_cute_a_botones() -> void:
	var estilo_normal = StyleBoxFlat.new()
	estilo_normal.bg_color = Color("f4e2bb") # Color crema cálido
	estilo_normal.set_corner_radius_all(8)  # Esquinas redondeadas
	estilo_normal.content_margin_left = 10
	estilo_normal.content_margin_right = 10
	estilo_normal.content_margin_top = 4
	estilo_normal.content_margin_bottom = 4

	var estilo_hover = estilo_normal.duplicate()
	estilo_hover.bg_color = Color("e9ce9b")

	var lista_botones = [boton_repisa, boton_sillon, boton_libros, boton_maceta, boton_chimenea, boton_mesa]
	
	for btn in lista_botones:
		if btn:
			btn.add_theme_stylebox_override("normal", estilo_normal)
			btn.add_theme_stylebox_override("hover", estilo_hover)
			btn.add_theme_stylebox_override("pressed", estilo_hover)
			btn.add_theme_color_override("font_color", Color("4a2e18"))
			btn.add_theme_color_override("font_hover_color", Color("2d1a0e"))


func actualizar_interfaz() -> void:
	if label_monedas:
		label_monedas.text = str(GameManager.monedas)
	
	actualizar_estado_boton(boton_repisa, "repisa_casa")
	actualizar_estado_boton(boton_sillon, "sillon_casa")
	actualizar_estado_boton(boton_libros, "libros_casa")
	actualizar_estado_boton(boton_maceta, "macetas_casa")
	actualizar_estado_boton(boton_chimenea, "chimenea_casa")
	actualizar_estado_boton(boton_mesa, "mesa_casa")


func actualizar_estado_boton(boton: Button, clave_mejora: String) -> void:
	if not boton: return
	
	var precio_texto = boton.text.replace("$", "").strip_edges()
	var precio = precio_texto.to_int()
	
	var comprado = GameManager.mejoras_desbloqueadas.get(clave_mejora, false)
	var sin_dinero = GameManager.monedas < precio
	
	boton.disabled = comprado or sin_dinero
	
	if comprado:
		boton.self_modulate = Color(1, 1, 1, 0.4)
	elif sin_dinero:
		boton.self_modulate = Color(0.8, 0.8, 0.8, 0.7)
	else:
		boton.self_modulate = Color(1, 1, 1, 1)


# --- ACCIONES DE COMPRA ---

func _on_botonsillon_pressed() -> void:
	comprar_item(boton_sillon, "sillon_casa")

func _on_botonrepisa_pressed() -> void:
	comprar_item(boton_repisa, "repisa_casa")

func _on_botonlibros_pressed() -> void:
	comprar_item(boton_libros, "libros_casa")

func _on_botonmaceta_pressed() -> void:
	comprar_item(boton_maceta, "macetas_casa")

func _on_botonadornochimenea_pressed() -> void:
	comprar_item(boton_chimenea, "chimenea_casa")

func _on_botonmesa1_pressed() -> void:
	comprar_item(boton_mesa, "mesa_casa")


func comprar_item(boton: Button, clave_mejora: String) -> void:
	var precio = boton.text.replace("$", "").strip_edges().to_int()
	
	if GameManager.monedas >= precio:
		GameManager.monedas -= precio
		GameManager.mejoras_desbloqueadas[clave_mejora] = true
		actualizar_interfaz()


# --- NUEVO: FUNCIÓN PARA CERRAR LA PANTALLA FLOTANTE ---
func _on_cerrar_pressed() -> void:
	# Cierra / elimina esta pantalla flotante de la escena actual
	queue_free()
