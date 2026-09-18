extends Node2D

#NIVELES GENERAL
@export var topos_a_derrotar:int 
@export var tiempo_huerta: float
@export_file("*.tscn") var siguiente_escena: String

@onready var camara: Camera2D = $Camera2D
@onready var spawner_topos: Marker2D = $SpawnerTopos
@onready var mensajes: Label = $Mensajes/Mensajes_nivel
#Acá despues si va mas ordenado en un HUD se cambia esto:
@onready var botones_huerta = $MundoHuertaPrueba/BotonesHuerta/ContenedorFade
var mejora_canion_techo = preload("res://Escenas/canion_techo.tscn")
#@export var desbloquear_valla: bool = false #NUEVA VARIABLE para desbloquear boton en nivel 2

func _ready() -> void:
	GameManager.topos_muertos_por_nivel = topos_a_derrotar
	GameManager.actualizar_topos.emit(GameManager.topos_derrotados)
	GameManager.actualizar_topos.connect(chequear_victoria)
	#if desbloquear_valla: #NUEVO PARA VER LA VALLA
	#	botones_huerta.get_node("BotonEscudo").show()
	#else:
	#	botones_huerta.get_node("BotonEscudo").hide() #NUEVO OCULTAR ESCUDO.NO SE PORQUE APARECE.
		
	#PARA PROBAR CAÑON:
	#GameManager.mejoras_desbloqueadas["canion_techo"] = true
	#GameManager.mejoras_desbloqueadas["herramienta_escudo"] = true
	#Funcion para Instanciar Mejoras de la tienda
	instanciar_mejoras()
	
	#Fases del nivel 1: Huerta y luego oleada de topos
	await fase_huerta(tiempo_huerta)
	await fase_oleada(5.0)
	
	#funcion movimiento de camara para iniciar oleada de topos
	animar_camara_inicio()
	
	
func animar_camara_inicio():
	#fade de botones huerta
	await fade_out(botones_huerta, 0.5)
	
	#movimiento de cámara:
	var posicion_original = camara.position
	var posicion_derecha = posicion_original + Vector2(1600, 0)
	var animacion_camara = create_tween()
	
	animacion_camara.tween_interval(1.0)
	animacion_camara.tween_property(camara, "position", posicion_derecha, 2.0).set_trans(Tween.TRANS_SINE)
	animacion_camara.tween_interval(1.0)
	animacion_camara.tween_property(camara, "position", posicion_original, 2.0).set_trans(Tween.TRANS_SINE)
	
	await animacion_camara.finished
	
	#fade in, vuelven los botones huerta:
	fade_in(botones_huerta, 0.5)

func mostrar_mensaje(msj: String) -> void:
	mensajes.text = msj
	mensajes.show()
	await get_tree().create_timer(3.0).timeout
	mensajes.hide()

func fase_huerta (tiempo: float) -> void:
	mostrar_mensaje("Tienes " + str(int(tiempo_huerta)) + " segundos para plantar!\n Arrastra las semillas a la tierra")
	await get_tree().create_timer(tiempo).timeout

func fase_oleada (tiempo: float) -> void:
	mostrar_mensaje("Cuidado que vienen los topos!\n Disparales con la tecla SPACE")
	spawner_topos.get_node("TimerOleada").start()	
	await get_tree().create_timer(tiempo).timeout
	
func fade_out(nodo: Node, tiempo: float) ->void:
	nodo.show()
	var fadeOut = create_tween()
	fadeOut.tween_property(nodo, "modulate:a", 0.0, tiempo).set_trans(Tween.TRANS_SINE)
	await fadeOut.finished
	nodo.hide()
	
func fade_in(nodo: Node, tiempo: float) ->void:
	nodo.modulate.a = 0.0
	nodo.show()
	var fadeIn = create_tween()
	fadeIn.tween_property(nodo, "modulate:a", 1.0, tiempo).set_trans(Tween.TRANS_SINE)
	
# por ahora tenemos la mejora del canion en el techo nada mas, aca se instancia:	
func instanciar_mejoras() -> void:
	if GameManager.mejoras_desbloqueadas["canion_techo"] == true:
		var nuevo_canion = mejora_canion_techo.instantiate()
		#nuevo_canion.global_position = global_position
		add_child(nuevo_canion)
	
#const ESCENA_VICTORIA = preload("res://nivel_1_completado.tscn")
func chequear_victoria (topos_muertos: int) -> void:
	
	if topos_muertos >= topos_a_derrotar:
		#print("Lograste la victoria! mataste 10 topos!")
		var timer = spawner_topos.get_node("TimerOleada")
		if timer != null:
			timer.stop()
		#señal para eliminar topos restantes:
		spawner_topos.eliminar_topos_restantes.emit()
		#AVISA AL GAME MANAGER CUAL ES EL SIGUIENTE NIVEL:
		GameManager.ruta_siguiente_nivel = siguiente_escena
		GameManager.nivel_1_completado = true
		#SALTAR A PANTALLA DE VICTORIA:
		get_tree().call_deferred("change_scene_to_file", "res://Escenas/nivel_1_completado.tscn")
