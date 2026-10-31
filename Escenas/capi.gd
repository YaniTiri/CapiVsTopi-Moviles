extends CharacterBody2D

class_name Capi

var vida: int = 100
var disparo_capi = preload("res://Escenas/disparo_capi.tscn")

@onready var timer_disparo: Timer = $TimerDisparo
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var topos_en_area_vision: int = 0

# --- NUEVO: SISTEMA DE CARRILES PARA EL CAPI ---
var carriles_y: Array[float] = [695.0, 735.0, 775.0] # Los mismos carriles de los topos
var indice_carril_actual: int = 1                     # Empezamos en el carril del medio (735.0)
var velocidad_cambio_carril: float = 15.0            # Qué tan rápido se mueve verticalmente

# Agregado variable para disparo manual
var puede_disparar_manual: bool = true
var esta_agachado: bool = false

func _ready() -> void:
	# Posicionamos al Capi en el carril inicial al arrancar
	global_position.y = carriles_y[indice_carril_actual]
	animation_player.play("capi_de_pie")
	pass
	

func _process(_delta: float) -> void:
  # --- 1. MOVIMIENTO ARRIBA Y ABAJO ENTRE CARRILES ---
	if Input.is_action_just_pressed("arriba"):
		if indice_carril_actual > 0:
			indice_carril_actual -= 1
	elif Input.is_action_just_pressed("abajo"):
		if indice_carril_actual < carriles_y.size() - 1:
			indice_carril_actual += 1

	# Suavizado de posición vertical con tipado estático
	var target_y: float = carriles_y[indice_carril_actual]
	global_position.y = lerp(global_position.y, target_y, velocidad_cambio_carril * delta)
  
	# --- 2. AGACHARSE ---
	if Input.is_action_pressed("agachado"):
		if !esta_agachado:
			esta_agachado = true
			animation_player.play("capi_agachado")
	else:
		if esta_agachado:
			esta_agachado = false
			animation_player.play("capi_de_pie")
  
  # --- 3. DISPARAR ---
	if Input.is_action_just_pressed("disparar") and puede_disparar_manual:
		puede_disparar_manual = false
		disparar()
		# Esperar 0.5 segundos antes de poder disparar otra vez
		await get_tree().create_timer(0.5).timeout
		puede_disparar_manual = true


# FUNC QUE SE ACTIVA CUANDO ALGO ENTRA EN EL AREA DE VISION DEL CAPI:
func _on_area_vision_body_entered(body: Node2D) -> void:
	if body is Topi:
		topos_en_area_vision += 1
		if timer_disparo.is_stopped():
			timer_disparo.start()


# SE EJECUTA CUANDO ALGO SALE DEL AREA:
func _on_area_vision_body_exited(body: Node2D) -> void:
	if body is Topi:
		topos_en_area_vision -= 1
		if topos_en_area_vision <= 0:
			timer_disparo.stop()


func _on_timer_disparo_timeout() -> void:
	pass
	
func disparar() -> void:
	animation_player.play("capi_disparando")
	if disparo_capi != null:
		var nuevo_disparo_capi = disparo_capi.instantiate()
		nuevo_disparo_capi.global_position = global_position
		get_parent().add_child(nuevo_disparo_capi)
		await animation_player.animation_finished
		$SonidoDisparo.play()
	animation_player.play("capi_de_pie")


func morir() -> void:
	animation_player.play("capi_muerto")
	await animation_player.animation_finished
	GameManager.mensaje_derrota = "Perdiste! Capi se quedó sin fuerza para defender la huerta!"
	GameManager.activar_game_over()
	queue_free()


func _on_gestor_de_hp_impacto_recibido(hp: int) -> void:
	GameManager.actualizar_vida_capi.emit(hp)


func _on_gestor_de_hp_body_entered(body: Node2D) -> void:
	if body is Topi:
		GameManager.mensaje_derrota = "Perdiste! Los topos invadieron la huerta!"
		GameManager.activar_game_over()
