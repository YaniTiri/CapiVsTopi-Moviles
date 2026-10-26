extends CanvasLayer

@onready var label_monedas: Label = $Sprite2D/Label

@onready var boton_repisa: Button = $Item_Repisa/Boton_repisa
@onready var boton_sillon: Button = $Item_Sillon/Boton_sillon
@onready var boton_libros: Button = $Item_Libros/Boton_libros
@onready var boton_maceta: Button = $Item_Maceta/Boton_Maceta
@onready var boton_chimenea: Button = $Item_Adorno_Chimenea/Boton_adornochimenea
@onready var boton_mesa: Button = $Item_Mesa1/Boton_mesa1


func _ready() -> void:
	# Monedas de prueba
	GameManager.monedas = 300
	actualizar_interfaz()


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
	
	# ESTÉTICA SUAVE: Si ya se compró, lo ponemos semitransparente (fantasmita) 
	# en vez de ponerlo negro y feo. Si está disponible, se ve radiante (1, 1, 1).
	if comprado:
		boton.self_modulate = Color(1, 1, 1, 0.4) # Transparente elegante
	elif sin_dinero:
		boton.self_modulate = Color(0.8, 0.8, 0.8, 0.7) # Un poco más apagado si no hay plata
	else:
		boton.self_modulate = Color(1, 1, 1, 1) # Normal y brilloso


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
