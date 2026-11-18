extends HBoxContainer

@onready var btn_izq: TextureButton = $BtnIzq
@onready var btn_actual: TextureButton = $BtnActual
@onready var btn_der: TextureButton = $BtnDer

# ACÁ AGREGÁS TODAS TUS FRUTAS Y VERDURAS CON SUS TEXTURAS Y SU ID
@export var ingredientes: Array[Dictionary] = [
	{
		"id": "mora",
		"textura": preload("res://botones/veduras_frutas/moras.png") 
	},
	{
		"id": "tomate",
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
		"id": "berejena",
		"textura": preload("res://botones/veduras_frutas/berejena.png") 
	},
	{
		"id": "calabaza",
		"textura": preload("res://botones/veduras_frutas/calabaza.png") 
	},
	{
		"id": "cereza",
		"textura": preload("res://botones/veduras_frutas/cerezas.png") 
	},
	{
		"id": "fruta_dragon",
		"textura": preload("res://botones/veduras_frutas/fruta_dragon.png") 
	},
	{
		"id": "frutilla",
		"textura": preload("res://botones/veduras_frutas/frutillas.png") 
	},
	{
		"id": "maices",
		"textura": preload("res://botones/veduras_frutas/maices.png") 
	},
	{
		"id": "uva",
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
