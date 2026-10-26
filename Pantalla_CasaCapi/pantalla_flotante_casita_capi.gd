extends CanvasLayer

# Referencia al Label dentro del Sprite2D (asegúrate de que el nodo Label se llame "Label" dentro de Sprite2D)
@onready var label_monedas: Label = $Sprite2D/Label

# Referencias a todos los botones de la casita
@onready var boton_repisa: Button = $Item_Repisa/Boton_repisa
@onready var boton_sillon: Button = $Item_Sillon/Boton_sillon
@onready var boton_libros: Button = $Item_Libros/Boton_libros
@onready var boton_maceta: Button = $Item_Maceta/Boton_Maceta
@onready var boton_chimenea: Button = $Item_Adorno_Chimenea/Boton_adornochimenea
@onready var boton_mesa: Button = $Item_Mesa1/Boton_mesa1


func _ready() -> void:
	# --- MONEDAS DE PRUEBA ---
	# Asignamos 300 monedas al GameManager para probar las compras
	GameManager.monedas = 300
	
	actualizar_interfaz()


func actualizar_interfaz() -> void:
	# 1. Asigna y muestra las monedas en el cartelito superior
	if label_monedas:
		label_monedas.text = str(GameManager.monedas)
	
	# 2. Revisa el estado de cada botón manteniendo la estética limpia
	actualizar_estado_boton(boton_repisa, "repisa_casa")
	actualizar_estado_boton(boton_sillon, "sillon_casa")
	actualizar_estado_boton(boton_libros, "libros_casa")
	actualizar_estado_boton(boton_maceta, "macetas_casa")
	actualizar_estado_boton(boton_chimenea, "chimenea_casa")
	actualizar_estado_boton(boton_mesa, "mesa_casa")


func actualizar_estado_boton(boton: Button, clave_mejora: String) -> void:
	if not boton: return
	
	# Extrae el precio numérico del texto del botón (ej: "$150" -> 150)
	var precio_texto = boton.text.replace("$", "").strip_edges()
	var precio = precio_texto.to_int()
	
	# Comprobamos si ya fue comprado o si no alcanzan las monedas
	var comprado = GameManager.mejoras_desbloqueadas.get(clave_mejora, false)
	var sin_dinero = GameManager.monedas < precio
	
	# Desactivamos el botón si no se puede comprar, pero SIN oscurecer con rectángulos feos
	boton.disabled = comprado or sin_dinero


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


# Lógica para cobrar y actualizar la plata
func comprar_item(boton: Button, clave_mejora: String) -> void:
	var precio = boton.text.replace("$", "").strip_edges().to_int()
	
	if GameManager.monedas >= precio:
		GameManager.monedas -= precio
		GameManager.mejoras_desbloqueadas[clave_mejora] = true
		actualizar_interfaz()
