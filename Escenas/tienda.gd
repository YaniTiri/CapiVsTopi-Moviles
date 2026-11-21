extends Node2D

@onready var boton_canion: TextureButton = $BotonCanion
@onready var boton_super_semillas: TextureButton = $BotonSuperSemillas
@onready var boton_escudo: TextureButton = $BotonValla
@onready var boton_pocion: TextureButton = $BotonPocion
@onready var boton_escudo_piedra: TextureButton = $BotonPiedra
@onready var boton_bomba: TextureButton = $BotonBomba
@onready var boton_ametralladora: TextureButton = $BotonAmetralladora
@onready var boton_agua: TextureButton = $BotonAgua
@onready var boton_azucar: TextureButton = $BotonAzucar
@onready var boton_aceite: TextureButton = $BotonAceite


func _ready() -> void:
	
	#PARA TESTEAR TIENDA:
	#GameManager.monedas=3000
	#GameManager.actualizar_monedas.emit(GameManager.monedas)
	
	actualizar_botones()

func actualizar_botones() -> void:
	# 1. BOTONES DE MEJORAS / COMBATE (Se bloquean si ya las compraste o no alcanzan las monedas)
	actualizar_estado_boton(boton_canion, "canion_techo")
	actualizar_estado_boton(boton_super_semillas, "semillas_poderosas")
	actualizar_estado_boton(boton_escudo, "herramienta_escudo")
	actualizar_estado_boton(boton_pocion, "pocion_curativa")
	actualizar_estado_boton(boton_escudo_piedra, "escudo_piedra")
	actualizar_estado_boton(boton_bomba, "bomba_anti_topos")
	actualizar_estado_boton(boton_ametralladora, "ametralladora_canion")

	# 2. INSUMOS DE COCINA (Libres: solo se bloquean si no alcanzan las monedas)
	actualizar_estado_ingrediente(boton_agua, "agua")
	actualizar_estado_ingrediente(boton_azucar, "azucar")
	actualizar_estado_ingrediente(boton_aceite, "aceite")


# Función auxiliar para mejoras: actualiza estado y el texto del Label de precio
func actualizar_estado_boton(boton: TextureButton, item_id: String) -> void:
	if boton == null:
		return
	
	var precio: int = GameManager.precios_mejoras.get(item_id, 0)
	var ya_desbloqueado: bool = GameManager.mejoras_desbloqueadas.get(item_id, false)
	
	# Habilitación y opacidad
	boton.disabled = ya_desbloqueado or GameManager.monedas < precio
	boton.modulate = Color(0.5, 0.5, 0.5) if boton.disabled else Color(1, 1, 1)

	# Actualización del Label hijo con el precio del GameManager
	actualizar_label_precio(boton, precio, ya_desbloqueado)
	

# Función auxiliar para insumos de cocina: actualiza estado y texto del Label de precio
func actualizar_estado_ingrediente(boton: TextureButton, item_id: String) -> void:
	if boton == null:
		return
	
	var precio: int = GameManager.precios_mejoras.get(item_id, 0)
	boton.disabled = GameManager.monedas < precio
	boton.modulate = Color(0.5, 0.5, 0.5) if boton.disabled else Color(1, 1, 1)

	# Actualización del Label hijo con el precio
	actualizar_label_precio(boton, precio, false)


# Busca el nodo Label hijo del botón y le actualiza el precio
func actualizar_label_precio(boton: TextureButton, precio: int, ya_desbloqueado: bool = false) -> void:
	var label: Label = boton.get_node_or_null("Label")
	if label != null:
		if ya_desbloqueado:
			label.text = "Comprado"
		else:
			label.text = "$ " + str(precio)
			
################################################################
func _on_boton_canion_pressed() -> void:
	GameManager.tienda_comprar("canion_techo")
	actualizar_botones()


func _on_boton_super_semillas_pressed() -> void:
	GameManager.tienda_comprar("semillas_poderosas")
	if GameManager.mejoras_desbloqueadas["semillas_poderosas"] == true:
		GameManager.semillas_poderosas_actuales(10)
	actualizar_botones()
	

func _on_boton_valla_pressed() -> void:
	GameManager.tienda_comprar("herramienta_escudo")
	actualizar_botones()

func _on_boton_pocion_pressed() -> void:
	GameManager.tienda_comprar("pocion_curativa")
	if GameManager.mejoras_desbloqueadas["pocion_curativa"] == true:
		GameManager.pociones_actuales(5)
	actualizar_botones()

func _on_boton_escudo_piedra_pressed() ->void:
	GameManager.tienda_comprar("escudo_piedra")
	if GameManager.mejoras_desbloqueadas["escudo_piedra"] == true:
		GameManager.vallas_piedra_actuales(3)
	actualizar_botones()

func _on_boton_bomba_pressed() ->void:
	GameManager.tienda_comprar("bomba_anti_topos")
	if GameManager.mejoras_desbloqueadas["bomba_anti_topos"] == true:
		GameManager.bombas_actuales(3)
	actualizar_botones()
	
func _on_boton_ametralladora_pressed() ->void:
	GameManager.tienda_comprar("ametralladora_canion")
	actualizar_botones()

# ==============================================================================
# COMPRAS DE INSUMOS DE COCINA (COMPRA LIBRE / REPETIBLE)
# ==============================================================================

func comprar_insumo_cocina(id_insumo: String) -> void:
	var precio: int = GameManager.precios_mejoras.get(id_insumo, 0)
	if GameManager.monedas >= precio:
		GameManager.monedas -= precio
		GameManager.actualizar_monedas.emit(GameManager.monedas)
		if InventoryManager:
			InventoryManager.agregar_ingrediente(id_insumo, 1)
		actualizar_botones()
		print("Compraste: ", id_insumo)
	else:
		print("Monedas insuficientes para: ", id_insumo)


func _on_boton_agua_pressed() -> void:
	comprar_insumo_cocina("agua")


func _on_boton_azucar_pressed() -> void:
	comprar_insumo_cocina("azucar")


func _on_boton_aceite_pressed() -> void:
	comprar_insumo_cocina("aceite")


func _on_siguiente_nivel_pressed() -> void:
	#Pasa al nivel que guardamos en el Game Manager al momento de la victoria anterior
	get_tree().change_scene_to_file(GameManager.ruta_siguiente_nivel)
