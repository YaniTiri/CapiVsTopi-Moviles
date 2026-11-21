extends HBoxContainer

@onready var btn_izq: TextureButton = $BtnIzq
@onready var btn_actual: TextureButton = $BtnActual
@onready var btn_der: TextureButton = $BtnDer
@onready var label_cantidad: Label = get_tree().current_scene.find_child("LabelCantidad", true, false)

@export var ingredientes: Array[Dictionary] = [
	{
		"id": "moras",
		"textura": preload("res://botones/veduras_frutas/moras.png")
	},
	{
		"id": "tomates",
		"textura": preload("res://botones/veduras_frutas/tomate.png")
	},
	{
		"id": "ajies",
		"textura": preload("res://botones/veduras_frutas/ajis.png")
	},
	{
		"id": "arandanos",
		"textura": preload("res://botones/veduras_frutas/arandanos.png")
	},
	{
		"id": "berenjenas",
		"textura": preload("res://botones/veduras_frutas/berejena.png")
	},
	{
		"id": "calabazas",
		"textura": preload("res://botones/veduras_frutas/calabaza.png")
	},
	{
		"id": "cerezas",
		"textura": preload("res://botones/veduras_frutas/cerezas.png")
	},
	{
		"id": "fruta_dragon",
		"textura": preload("res://botones/veduras_frutas/fruta_dragon.png")
	},
	{
		"id": "frutillas",
		"textura": preload("res://botones/veduras_frutas/frutillas.png")
	},
	{
		"id": "maices",
		"textura": preload("res://botones/veduras_frutas/maices.png")
	},
	{
		"id": "uvas",
		"textura": preload("res://botones/veduras_frutas/uvas.png")
	},
]

var indice_actual: int = 0

func _ready() -> void:
	btn_izq.pressed.connect(_on_flecha_izq_pressed)
	btn_der.pressed.connect(_on_flecha_der_pressed)
	actualizar_carrusel()

func _on_flecha_izq_pressed() -> void:
	indice_actual = wrapi(indice_actual - 1, 0, ingredientes.size())
	actualizar_carrusel()

func _on_flecha_der_pressed() -> void:
	indice_actual = wrapi(indice_actual + 1, 0, ingredientes.size())
	actualizar_carrusel()

func actualizar_carrusel() -> void:
	if ingredientes.is_empty():
		return
	
	var item_actual = ingredientes[indice_actual]
	
	# 1. Cambiamos la imagen del botón central
	btn_actual.texture_normal = item_actual["textura"]
	
	# 2. Actualizamos automáticamente el ID para que al arrastrar sepa qué ingrediente es
	btn_actual.id_item = item_actual["id"]
	
	# 3. Actualizamos el número del redondel
	actualizar_contador_actual()

func actualizar_contador_actual() -> void:
	if label_cantidad == null:
		label_cantidad = get_tree().current_scene.find_child("LabelCantidad", true, false)
	if label_cantidad == null or ingredientes.is_empty():
		return

	var id_actual: String = ingredientes[indice_actual]["id"]
	var cantidad := 0

	var zona_olla = get_tree().current_scene.find_child("ZonaOlla", true, false)
	if zona_olla != null and zona_olla.has_method("_obtener_stock_real"):
		cantidad = zona_olla._obtener_stock_real(id_actual)
	elif has_node("/root/InventoryManager"):
		var inv = get_node("/root/InventoryManager")
		if inv.has_method("obtener_cantidad_fruto"):
			cantidad = inv.obtener_cantidad_fruto(id_actual)
		elif "frutos_cosechados" in inv:
			cantidad = inv.frutos_cosechados.get(id_actual, 0)

	label_cantidad.text = str(cantidad)
