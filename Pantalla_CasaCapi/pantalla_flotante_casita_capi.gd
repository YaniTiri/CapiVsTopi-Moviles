extends CanvasLayer

# Imagen del cartel (verificá la ruta: clic derecho en el archivo -> Copiar ruta)
const TEXTURA_PRECIO = preload("res://Escenas/assets/Pantalla_Flotante/Boton_precios.png")

# Tamaño único para todos los carteles de precio
const TAMANO_CARTEL = Vector2(300, 120)

@onready var label_monedas: Label = $Sprite2D/Label

# Buscamos los botones por nombre, así no importa en qué parte del árbol estén
# (los nombres tienen que ser EXACTAMENTE estos, con sus mayúsculas)
@onready var boton_repisa: Button = find_child("Boton_repisa", true, false) as Button
@onready var boton_sillon: Button = find_child("Boton_sillon", true, false) as Button
@onready var boton_libros: Button = find_child("Boton_libros", true, false) as Button
@onready var boton_maceta: Button = find_child("Boton_Maceta", true, false) as Button
@onready var boton_chimenea: Button = find_child("Boton_adornochimenea", true, false) as Button
@onready var boton_mesa: Button = find_child("Boton_mesa1", true, false) as Button

# Referencia al botón de cerrar
@onready var boton_cerrar: Button = $Cerrar


func _ready() -> void:
	# Monedas de prueba
	GameManager.monedas = 300

	conectar_botones()
	aplicar_estilo_a_botones()
	actualizar_interfaz()

	# Esperamos un frame y volvemos a fijar el tamaño para que nada lo pise
	await get_tree().process_frame
	for btn in obtener_botones():
		if btn:
			btn.size = TAMANO_CARTEL


func obtener_botones() -> Array:
	return [boton_repisa, boton_sillon, boton_libros, boton_maceta, boton_chimenea, boton_mesa]


# Conecta las señales por código (si ya estaban conectadas desde el editor, no las duplica)
func conectar_botones() -> void:
	var conexiones = [
		[boton_sillon, _on_botonsillon_pressed],
		[boton_repisa, _on_botonrepisa_pressed],
		[boton_libros, _on_botonlibros_pressed],
		[boton_maceta, _on_botonmaceta_pressed],
		[boton_chimenea, _on_botonadornochimenea_pressed],
		[boton_mesa, _on_botonmesa1_pressed],
	]
	for par in conexiones:
		var btn: Button = par[0]
		var accion: Callable = par[1]
		if btn == null:
			push_warning("Falta un botón, revisá los nombres de los nodos")
			continue
		if not btn.pressed.is_connected(accion):
			btn.pressed.connect(accion)


func crear_estilo(tinte: Color = Color.WHITE) -> StyleBoxTexture:
	var estilo = StyleBoxTexture.new()
	estilo.texture = TEXTURA_PRECIO
	# Márgenes del 9-slice (grosor del borde de madera)
	estilo.texture_margin_left = 20
	estilo.texture_margin_right = 20
	estilo.texture_margin_top = 20
	estilo.texture_margin_bottom = 20
	estilo.modulate_color = tinte
	return estilo


func aplicar_estilo_a_botones() -> void:
	for btn in obtener_botones():
		if btn == null:
			continue

		# Reseteamos lo que pudo quedar de pruebas anteriores
		btn.custom_minimum_size = Vector2.ZERO
		btn.scale = Vector2.ONE
		btn.rotation = 0.0
		btn.size = TAMANO_CARTEL

		# Que se dibuje por encima de las imágenes de fondo
		btn.z_index = 10
		btn.move_to_front()

		# El texto (precio) NO se toca: se usa el que pusiste en cada botón
		btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
		btn.clip_text = false

		# Texto grande y legible, igual en todos
		btn.add_theme_font_size_override("font_size", 40)
		btn.add_theme_color_override("font_color", Color.WHITE)
		btn.add_theme_color_override("font_hover_color", Color.WHITE)
		btn.add_theme_color_override("font_pressed_color", Color.WHITE)
		btn.add_theme_color_override("font_disabled_color", Color.WHITE)
		btn.add_theme_color_override("font_outline_color", Color.BLACK)
		btn.add_theme_constant_override("outline_size", 6)

		# Estilos con la imagen de madera (incluido "disabled" para comprados / sin dinero)
		btn.add_theme_stylebox_override("normal", crear_estilo())
		btn.add_theme_stylebox_override("hover", crear_estilo(Color(1.2, 1.2, 1.2)))
		btn.add_theme_stylebox_override("pressed", crear_estilo(Color(0.8, 0.8, 0.8)))
		btn.add_theme_stylebox_override("disabled", crear_estilo())
		btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


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


# --- FUNCIÓN PARA CERRAR LA PANTALLA FLOTANTE ---
func _on_cerrar_pressed() -> void:
	queue_free()
