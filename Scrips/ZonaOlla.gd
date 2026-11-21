extends Control

# Tus recetas perfectas
var recetas = {
	"mermelada_tomate": { "ingredientes": { "tomates": 10, "azucar": 5, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_frutilla": { "ingredientes": { "frutillas": 10, "azucar": 5, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_arandano": { "ingredientes": { "arandanos": 15, "azucar": 5, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_cereza": { "ingredientes": { "cerezas": 15, "azucar": 6, "agua": 2 }, "tiempo_coccion": 10.0 },
	"mermelada_fruta_dragon": { "ingredientes": { "fruta_dragon": 5, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"mermelada_mora": { "ingredientes": { "moras": 4, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"mermelada_uva": { "ingredientes": { "uvas": 4, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"mermelada_calabaza": { "ingredientes": { "calabazas": 1, "azucar": 2, "agua": 1 }, "tiempo_coccion": 10.0 },
	"maiz_tostado": { "ingredientes": { "maices": 5, "aceite": 3, "sal": 1 }, "tiempo_coccion": 10.0 },
	"salsa_tomate": { "ingredientes": { "tomates": 8, "aceite": 1 }, "tiempo_coccion": 10.0 },
	"berenjenas_escabeche": { "ingredientes": { "berenjenas": 6, "agua": 3, "vinagre": 2 }, "tiempo_coccion": 10.0 },
	"conservar_ajies": { "ingredientes": { "ajies": 5, "aceite": 3 }, "tiempo_coccion": 10.0 }
}

var contenido_olla: Dictionary = {}
var estado: String = "VACIA" # VACIA, COCINANDO, LISTO
var receta_actual: String = ""

@onready var timer_coccion: Timer = Timer.new()
@onready var indicador_listo: Label = $IndicadorListo
@onready var texto_timer: Label = $TextoTimer
@onready var label_cosecha: Label = get_node_or_null("LabelCosecha")

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if indicador_listo: indicador_listo.visible = false
	if texto_timer: texto_timer.visible = false
	
	add_child(timer_coccion)
	timer_coccion.one_shot = true
	timer_coccion.timeout.connect(_on_coccion_terminada)
	_refrescar_contadores()

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
	_refrescar_contadores()

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
	_descontar_frutos_al_cocinar()
	estado = "COCINANDO"
	receta_actual = nombre_receta
	var tiempo = 5.0 if (nombre_receta == "mermelada_fea" or nombre_receta == "mermelada_sin_sabor") else recetas[nombre_receta]["tiempo_coccion"]
	
	timer_coccion.start(tiempo)
	print("¡Cocinando ", nombre_receta, " por ", tiempo, " segundos...")
	
	if indicador_listo: indicador_listo.visible = false
	if texto_timer: 
		texto_timer.visible = true
		texto_timer.modulate = Color(1, 1, 1, 1)
	_refrescar_contadores()

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
	_registrar_producto_elaborado(receta_actual)
	print("¡Envasaste 1 frasco de ", receta_actual, "!")
	reiniciar_olla()

func reiniciar_olla() -> void:
	contenido_olla.clear()
	receta_actual = ""
	estado = "VACIA"
	if indicador_listo: indicador_listo.visible = false
	if texto_timer: texto_timer.visible = false
	_refrescar_contadores()

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

func _obtener_stock_real(id_ingrediente: String) -> int:
	var total := 0
	
	# 1. Revisamos inventory_manager.gd (frutos_cosechados)
	var inv = get_node_or_null("/root/InventoryManager")
	if inv == null:
		inv = get_node_or_null("/root/inventory_manager")
		
	if inv != null:
		if inv.has_method("obtener_cantidad_fruto"):
			total = inv.obtener_cantidad_fruto(id_ingrediente)
		elif "frutos_cosechados" in inv:
			total = inv.frutos_cosechados.get(id_ingrediente, 0)
			
	# 2. Respaldo con game_manager.gd si es tomate y ahí figura cosechado
	if total == 0 and id_ingrediente == "tomates":
		var gm = get_node_or_null("/root/GameManager")
		if gm == null:
			gm = get_node_or_null("/root/game_manager")
		if gm != null and "tomates_cosechados" in gm:
			total = gm.tomates_cosechados

	# Si está vacía (antes de cocinar), restamos lo ya cargado en la olla para vista previa
	if estado == "VACIA":
		total = max(0, total - contenido_olla.get(id_ingrediente, 0))
			
	return total

func _descontar_frutos_al_cocinar() -> void:
	var inv = get_node_or_null("/root/InventoryManager")
	if inv == null:
		inv = get_node_or_null("/root/inventory_manager")
	var gm = get_node_or_null("/root/GameManager")
	if gm == null:
		gm = get_node_or_null("/root/game_manager")

	for id_ing in contenido_olla:
		var cant: int = contenido_olla[id_ing]
		if cant <= 0:
			continue

		if inv != null and "frutos_cosechados" in inv and id_ing in inv.frutos_cosechados:
			var actual: int = inv.frutos_cosechados[id_ing]
			var restado: int = min(actual, cant)
			inv.frutos_cosechados[id_ing] = actual - restado
			var sobrante: int = cant - restado
			if sobrante > 0 and id_ing == "tomates" and gm != null and "tomates_cosechados" in gm:
				gm.tomates_cosechados = max(0, gm.tomates_cosechados - sobrante)
		elif id_ing == "tomates" and gm != null and "tomates_cosechados" in gm:
			gm.tomates_cosechados = max(0, gm.tomates_cosechados - cant)

func _registrar_producto_elaborado(nombre_prod: String) -> void:
	if nombre_prod.is_empty():
		return
	var inv = get_node_or_null("/root/InventoryManager")
	if inv == null:
		inv = get_node_or_null("/root/inventory_manager")
	if inv != null and "productos_elaborados" in inv:
		inv.productos_elaborados[nombre_prod] = inv.productos_elaborados.get(nombre_prod, 0) + 1

func actualizar_panel_cosecha() -> void:
	if label_cosecha == null:
		return
	var partes: Array[String] = []
	var claves := ["tomates", "berenjenas", "ajies", "uvas", "maices", "frutillas", "moras", "calabazas", "arandanos", "cerezas", "fruta_dragon"]
	for clave in claves:
		var restante = _obtener_stock_real(clave)
		if restante > 0:
			partes.append(clave.capitalize() + ": " + str(restante))
	label_cosecha.text = "Cosechado: " + (" | ".join(partes) if not partes.is_empty() else "0")

func _refrescar_contadores() -> void:
	actualizar_panel_cosecha()
	var carrusel = get_tree().current_scene.find_child("CarruselFrutas", true, false)
	if carrusel and carrusel.has_method("actualizar_contador_actual"):
		carrusel.actualizar_contador_actual()
