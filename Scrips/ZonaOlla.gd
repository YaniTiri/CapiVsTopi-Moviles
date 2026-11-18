extends Control

# Tus recetas perfectas
var recetas = {
	"mermelada_tomate": { "ingredientes": { "tomate": 10, "azucar": 5, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_frutilla": { "ingredientes": { "frutilla": 10, "azucar": 5, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_arandano": { "ingredientes": { "arandano": 15, "azucar": 5, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_cereza": { "ingredientes": { "cereza": 15, "azucar": 6, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_fruta_dragon": { "ingredientes": { "fruta_dragon": 5, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"mermelada_mora": { "ingredientes": { "mora": 4, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"mermelada_uva": { "ingredientes": { "uva": 4, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"mermelada_calabaza": { "ingredientes": { "calabaza": 1, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"maiz_tostado": { "ingredientes": { "maiz": 5, "aceite": 3, "sal": 1 }, "tiempo_coccion": 10.0 },
	"salsa_tomate": { "ingredientes": { "tomate": 8, "aceite": 1 }, "tiempo_coccion": 10.0 },
	"berenjenas_escabeche": { "ingredientes": { "berenjena": 6, "agua": 3, "vinagre": 2 }, "tiempo_coccion": 10.0 },
	"conservar_ajies": { "ingredientes": { "ajies": 5, "aceite": 3 }, "tiempo_coccion": 10.0 }
}

var contenido_olla: Dictionary = {}
var estado: String = "VACIA" # VACIA, COCINANDO, LISTO
var receta_actual: String = ""

@onready var timer_coccion: Timer = Timer.new()
@onready var indicador_listo: Label = $IndicadorListo
@onready var texto_timer: Label = $TextoTimer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if indicador_listo: indicador_listo.visible = false
	if texto_timer: texto_timer.visible = false
	
	add_child(timer_coccion)
	timer_coccion.one_shot = true
	timer_coccion.timeout.connect(_on_coccion_terminada)

func _process(_delta: float) -> void:
	if estado == "COCINANDO" and texto_timer:
		var tiempo_restante = ceil(timer_coccion.time_left)
		texto_timer.text = "Cocinando: " + str(tiempo_restante) + "s"

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY or not data.has("tipo"):
		return false
	if data["tipo"] == "ingrediente" and estado == "VACIA":
		return true
	if data["tipo"] == "frasco" and estado == "LISTO":
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data["tipo"] == "ingrediente":
		if data.has("textura") and data["textura"] != null:
			mostrar_ingrediente_cayendo(data["textura"])
		agregar_ingrediente(data["id"])
	elif data["tipo"] == "frasco" and estado == "LISTO":
		envasar_dulce()

# ACCIÓN AL TOCAR LA OLLA
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if estado == "VACIA" and not contenido_olla.is_empty():
			cocinar_mezcla_actual()
		elif estado == "COCINANDO" or estado == "LISTO":
			print("Olla limpiada.")
			reiniciar_olla()

func agregar_ingrediente(id: String) -> void:
	contenido_olla[id] = contenido_olla.get(id, 0) + 1
	print("En la olla hay: ", contenido_olla)

# Evalúa si la receta es perfecta, incompleta (sin sabor) o excedida (fea)
func cocinar_mezcla_actual() -> void:
	var receta_encontrada = ""
	
	# 1. Revisamos si coincide exactamente con una receta perfecta
	for nombre_receta in recetas:
		if contenido_olla == recetas[nombre_receta]["ingredientes"]:
			receta_encontrada = nombre_receta
			break
			
	if receta_encontrada != "":
		iniciar_coccion(receta_encontrada)
		return

	# 2. Verificamos si puso MENOS ingredientes de los que pide alguna receta (Sin Sabor)
	var es_incompleto = false
	for nombre_receta in recetas:
		var reqs = recetas[nombre_receta]["ingredientes"]
		var valido_hasta_ahora = true
		var tiene_al_menos_algo = false
		
		for ing in contenido_olla:
			if ing in reqs and contenido_olla[ing] <= reqs[ing]:
				tiene_al_menos_algo = true
			else:
				valido_hasta_ahora = false
				break
				
		if valido_hasta_ahora and tiene_al_menos_algo:
			es_incompleto = true
			break
			
	if es_incompleto:
		iniciar_coccion("mermelada_sin_sabor")
	else:
		# 3. Si se pasó de cantidad o mezcló cosas que no van -> Mermelada Fea
		iniciar_coccion("mermelada_fea")

func iniciar_coccion(nombre_receta: String) -> void:
	estado = "COCINANDO"
	receta_actual = nombre_receta
	var tiempo = 5.0 if (nombre_receta == "mermelada_fea" or nombre_receta == "mermelada_sin_sabor") else recetas[nombre_receta]["tiempo_coccion"]
	
	timer_coccion.start(tiempo)
	print("¡Cocinando ", nombre_receta, " por ", tiempo, " segundos...")
	
	if indicador_listo: indicador_listo.visible = false
	if texto_timer: 
		texto_timer.visible = true
		texto_timer.modulate = Color(1, 1, 1, 1)

func _on_coccion_terminada() -> void:
	estado = "LISTO"
	print("¡", receta_actual, " está listo! Arrastrá el frasco a la olla.")
	
	if texto_timer: texto_timer.visible = false
	if indicador_listo:
		var texto_aviso = ""
		var color_aviso = Color(1, 1, 1, 1)
		
		if receta_actual == "mermelada_fea":
			texto_aviso = "¡MERMELADA FEA!"
			color_aviso = Color(1, 0.4, 0.4, 1) # Rojo alerta
		elif receta_actual == "mermelada_sin_sabor":
			texto_aviso = "¡SIN SABOR!"
			color_aviso = Color(0.8, 0.8, 0.8, 1) # Gris apagado
		else:
			texto_aviso = "¡" + receta_actual.to_upper() + " LISTO!"
			color_aviso = Color(0.4, 1, 0.4, 1) # Verde éxito
			
		indicador_listo.text = texto_aviso
		indicador_listo.visible = true
		indicador_listo.modulate = color_aviso

func envasar_dulce() -> void:
	print("¡Envasaste 1 frasco de ", receta_actual, "!")
	reiniciar_olla()

func reiniciar_olla() -> void:
	contenido_olla.clear()
	receta_actual = ""
	estado = "VACIA"
	if indicador_listo: indicador_listo.visible = false
	if texto_timer: texto_timer.visible = false

func mostrar_ingrediente_cayendo(textura: Texture2D) -> void:
	var sprite = TextureRect.new()
	sprite.texture = textura
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.custom_minimum_size = Vector2(64, 64)
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	sprite.position = (size / 2) - Vector2(32, 80)
	add_child(sprite)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "position:y", sprite.position.y + 60, 0.35)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.35)
	tween.chain().tween_callback(sprite.queue_free)
