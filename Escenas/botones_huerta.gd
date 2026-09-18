extends CanvasLayer

var herramienta_semillas_scene = preload("res://Escenas/herramienta_semillas.tscn")
var herramienta_regadera_scene = preload("res://Escenas/herramienta_regadera.tscn")
var herramienta_cosechar_scene = preload("res://Escenas/herramienta_cosechar.tscn")
var herramienta_escudo_scene = preload("res://Escenas/herramienta_escudo.tscn")
var herramienta_super_semillas_scene= preload("res://Escenas/herramienta_super_semillas.tscn")

func _ready() -> void:
	if GameManager.mejoras_desbloqueadas["herramienta_escudo"] == true:
		$ContenedorFade/BotonEscudo.show()
	else:
		$ContenedorFade/BotonEscudo.hide()
	
	GameManager.actualizar_semillas_poderosas.connect(actualizar_hud_semillas)
	actualizar_hud_semillas(GameManager.semillas_poderosas)
	
		
func actualizar_hud_semillas(cantidad: int) -> void:
	if cantidad > 0:
		$ContenedorFade/BotonSemillas.texture_normal = load("res://Assets/botonSuperSemillas.png")
		$ContenedorFade/SemillasPoderosasLabel.text = "x" + str(cantidad)
	else:
		$ContenedorFade/BotonSemillas.texture_normal = load("res://Assets/botonSemillas.png")
		$ContenedorFade/SemillasPoderosasLabel.text = ""
		$ContenedorFade/SemillasPoderosasLabel.hide()
		

		
func _on_boton_semillas_button_down() -> void:
	var nueva_bolsa = null
	if GameManager.semillas_poderosas > 0:
		#instanciamos la bolsa
		nueva_bolsa = herramienta_super_semillas_scene.instantiate()
		#la agregamos como hija del nivel
		get_parent().add_child(nueva_bolsa)
	else:
		#instanciamos la bolsa
		nueva_bolsa = herramienta_semillas_scene.instantiate()
		#la agregamos como hija del nivel
		get_parent().add_child(nueva_bolsa)
	#le damos la posicion del mouse a la nueva bolsa
	nueva_bolsa.global_position = nueva_bolsa.get_global_mouse_position()
	#busca el componente Drag and Drop de la bolsa y le damos true
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
	var nuevo_escudo = herramienta_escudo_scene.instantiate()
	get_parent().add_child(nuevo_escudo)
	nuevo_escudo.global_position = nuevo_escudo.get_global_mouse_position()
	var componente_drag_and_drop = nuevo_escudo.get_node("D&dcomponent")
	componente_drag_and_drop.dragging = true
	
