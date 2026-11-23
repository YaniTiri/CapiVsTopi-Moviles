extends CanvasLayer

var herramienta_semillas_scene = preload("res://Escenas/herramienta_semillas.tscn")
var herramienta_regadera_scene = preload("res://Escenas/herramienta_regadera.tscn")
var herramienta_cosechar_scene = preload("res://Escenas/herramienta_cosechar.tscn")
var herramienta_escudo_scene = preload("res://Escenas/herramienta_escudo.tscn")
var herramienta_super_semillas_scene= preload("res://Escenas/herramienta_super_semillas.tscn")
var herramienta_escudo_piedra_scene = preload("res://Escenas/herramienta_escudo_piedra.tscn")
var escena_explosion = preload("res://Escenas/explosion.tscn")

@onready var boton_pocion: TextureButton = $ContenedorFade/BotonPocion
@onready var label_pocion: Label = $ContenedorFade/PocionesLabel
@onready var timer_pocion: Timer = $ContenedorFade/BotonPocion/TimerPocion
@onready var boton_bomba: TextureButton = $ContenedorFade/BotonBomba
@onready var label_bomba: Label = $ContenedorFade/BombaLabel
@onready var timer_bomba: Timer = $ContenedorFade/BotonBomba/TimerBomba


func _ready() -> void:
	if GameManager.mejoras_desbloqueadas["herramienta_escudo"] == true:
		$ContenedorFade/BotonEscudo.show()
	else:
		$ContenedorFade/BotonEscudo.hide()
	
	#semillas poderosas:
	GameManager.actualizar_semillas_poderosas.connect(actualizar_hud_semillas)
	actualizar_hud_semillas(GameManager.semillas_poderosas)
	
	#vallas piedra:
	GameManager.actualizar_vallas_piedra.connect(actualizar_hud_vallas)
	actualizar_hud_vallas(GameManager.vallas_piedra)
	
	# Pociones:
	GameManager.actualizar_vida_capi.connect(_on_vida_capi_cambio)
	GameManager.actualizar_pociones.connect(actualizar_hud_pociones)
	actualizar_hud_pociones(GameManager.pociones_curativas)
	
	timer_pocion.timeout.connect(_on_timer_pocion_terminado)
	
	# bombas:
	GameManager.actualizar_bombas.connect(actualizar_hud_bombas)
	actualizar_hud_bombas(GameManager.bombas_anti_topos)
	timer_bomba.timeout.connect(_on_timer_bomba_terminado)
		
func actualizar_hud_semillas(cantidad: int) -> void:
	if cantidad > 0:
		$ContenedorFade/BotonSemillas.texture_normal = load("res://Assets/botonSuperSemillas.png")
		$ContenedorFade/SemillasPoderosasLabel.text = "x" + str(cantidad)
	else:
		$ContenedorFade/BotonSemillas.texture_normal = load("res://Assets/botonSemillas.png")
		$ContenedorFade/SemillasPoderosasLabel.text = ""
		$ContenedorFade/SemillasPoderosasLabel.hide()
		
func actualizar_hud_vallas(cantidad: int) -> void:
	var label_vallas = $ContenedorFade/VallasPiedraLabel
	
	if cantidad > 0:
		# Cambia a la textura de piedra (poné la ruta exacta de tu imagen si la tenés):
		$ContenedorFade/BotonEscudo.texture_normal = load("res://Assets/boton_piedra.png")
		if label_vallas != null:
			label_vallas.text = "x" + str(cantidad)
			label_vallas.show()
	else:
		# Vuelve a la valla de madera normal:
		$ContenedorFade/BotonEscudo.texture_normal = load("res://Assets/botonescudo.png")
		if label_vallas != null:
			label_vallas.text = ""
			label_vallas.hide()

func actualizar_hud_pociones(cantidad: int) -> void:
	if cantidad > 0:
		boton_pocion.show()
		label_pocion.text = "x" + str(cantidad)
		label_pocion.show()
		#inicia deshabilitado
		boton_pocion.disabled = true
		boton_pocion.modulate = Color(0.4, 0.4, 0.4)
	else:
		boton_pocion.hide()
		label_pocion.hide()

func actualizar_hud_bombas(cantidad: int) -> void:
	if cantidad > 0:
		boton_bomba.show()
		if label_bomba != null:
			label_bomba.text = "x" + str(cantidad)
			label_bomba.show()
	else:
		boton_bomba.hide()
		if label_bomba != null:
			label_bomba.hide()

func _on_vida_capi_cambio(hp_actual: int) -> void:

	if GameManager.pociones_curativas <= 0 or not timer_pocion.is_stopped():
		return
	
	# Si la vida está al 100 se deshabilita
	if hp_actual >= 100:
		boton_pocion.disabled = true
		boton_pocion.modulate = Color(0.4, 0.4, 0.4) # Oscuro
	else:
		# Si el capi recibe daño se habilita la pocion
		boton_pocion.disabled = false
		boton_pocion.modulate = Color(1, 1, 1) # Normal

func _on_timer_pocion_terminado() -> void:
	# Cuando termina el timer:
	if GameManager.pociones_curativas > 0:
		boton_pocion.disabled = false
		boton_pocion.modulate = Color(1, 1, 1) 
		
func _on_boton_pocion_pressed() -> void:
	
	if GameManager.pociones_curativas <= 0 or not timer_pocion.is_stopped():
		return
	
	var barra = $"../Barra_vida/Barra_vida_base/TextureProgressBar"
	if barra.value >= 100:
		print("Capi ya tiene la vida al máximo. No se gasta la poción.")
		return
	
	GameManager.curar_capi.emit(50)
	GameManager.pociones_actuales(-1)
	
	# Efecto visual oscuro:
	boton_pocion.disabled = true
	boton_pocion.modulate = Color(0.4, 0.4, 0.4)
	timer_pocion.start()


		
func _on_boton_semillas_button_down() -> void:
	var nueva_bolsa = null
	if GameManager.semillas_poderosas > 0:
		nueva_bolsa = herramienta_super_semillas_scene.instantiate()
		get_parent().add_child(nueva_bolsa)
	else:
		nueva_bolsa = herramienta_semillas_scene.instantiate()
		get_parent().add_child(nueva_bolsa)
	nueva_bolsa.global_position = nueva_bolsa.get_global_mouse_position()
	var componente_drag_and_drop = nueva_bolsa.get_node("D&dcomponent")
	componente_drag_and_drop.dragging = true
	


func _on_boton_regadera_button_down() -> void:
	var nueva_regadera = herramienta_regadera_scene.instantiate()
	get_parent().add_child(nueva_regadera)
	nueva_regadera.global_position = nueva_regadera.get_global_mouse_position()
	var componente_drag_and_drop = nueva_regadera.get_node("D&dcomponent")
	componente_drag_and_drop.dragging = true
	


func _on_boton_canasta_button_down() -> void:
	var nueva_canasta = herramienta_cosechar_scene.instantiate()
	get_parent().add_child(nueva_canasta)
	nueva_canasta.global_position = nueva_canasta.get_global_mouse_position()
	var componente_drag_and_drop = nueva_canasta.get_node("D&dcomponent")
	componente_drag_and_drop.dragging = true


func _on_boton_escudo_button_down() -> void:	#instanciamos valla
	var nuevo_escudo = null
	# Si el jugador tiene vallas de piedra, instancia la de piedra:
	if GameManager.vallas_piedra > 0:
		nuevo_escudo = herramienta_escudo_piedra_scene.instantiate()
	else:
		nuevo_escudo = herramienta_escudo_scene.instantiate()
		
	get_parent().add_child(nuevo_escudo)
	nuevo_escudo.global_position = nuevo_escudo.get_global_mouse_position()
	var componente_drag_and_drop = nuevo_escudo.get_node("D&dcomponent")
	componente_drag_and_drop.dragging = true
	
func _on_boton_bomba_pressed() -> void:
	if GameManager.bombas_anti_topos <= 0 or not timer_bomba.is_stopped():
		return
		
	GameManager.bombas_actuales(-1)
	actualizar_hud_bombas(GameManager.bombas_anti_topos)
	
	# Si todavía le quedan bombas, se deshabilita y empieza el timer:
	if GameManager.bombas_anti_topos > 0:
		boton_bomba.disabled = true
		boton_bomba.modulate = Color(0.4, 0.4, 0.4) # Oscuro
		timer_bomba.start()
	
	#activa la animacion de la explosion:
	if escena_explosion != null:
		var boom = escena_explosion.instantiate()
		get_parent().add_child(boom)
		
	# mata a todos los topos que se ven:	
	var area_pantalla = get_tree().current_scene.get_node_or_null("AreaPiso")
	if area_pantalla != null:
		# mata SOLO los topos que tocan el area:
		var cuerpos = area_pantalla.get_overlapping_bodies()
		for cuerpo in cuerpos:
			if is_instance_valid(cuerpo):
				if cuerpo is Topi and cuerpo.has_method("morir"):
					cuerpo.morir()
					await get_tree().create_timer(0.15).timeout
	else:
		print("ERROR: No se encontró AreaPiso")
	
func _on_timer_bomba_terminado() -> void:
	# Si quedan bombas se vuelve a habilitar:
	if GameManager.bombas_anti_topos > 0:
		boton_bomba.disabled = false
		boton_bomba.modulate = Color(1, 1, 1) # Normal
