extends Node2D

var disparo_tomate = preload("res://Escenas/disparo_tomate.tscn")
@onready var timer_canion: Timer = $TimerCanion

# Diferentes disparos:
@export var disparo_canion: float = 1.5      
@export var disparo_ametralladora: float = 0.45     

@onready var sprite_canion: Sprite2D = $canion_techo
@onready var sprite_ametralladora: Sprite2D = $canion_ametralladora

#SALIDA CAÑÓN COMÚN:
@onready var salida_canion: Marker2D = $SalidaCanion

#SALIDAS AMETRALLADORA:
@onready var salidas_ametralladora: Array[Marker2D] = [
	$SalidaAmetralla1,
	$SalidaAmetralla2,
	$SalidaAmetralla3,
	$SalidaAmetralla4
]

# Fuerza diferente para las diferentes disparos de la ametralladora
var fuerzas_disparo: Array[float] = [850.0, 1050.0, 1250.0, 1500.0]
# indica cual canion de la ametralladora va:
var indice_canion_actual: int = 0

var topos_en_area_vision: int = 0
var es_ametralladora: bool = false


func _ready() -> void:
	timer_canion.timeout.connect(_on_timer_canion_timeout)
	
	# Chequeamos si está la mejora ametralladora:
	if GameManager.mejoras_desbloqueadas["ametralladora_canion"] == true:
		es_ametralladora = true
		timer_canion.wait_time = disparo_ametralladora
		
		# se ve ametralladora y oculta el canion:
		if sprite_ametralladora:
			sprite_ametralladora.show()
		if sprite_canion:
			sprite_canion.hide()
			
	else:
		es_ametralladora = false
		timer_canion.wait_time = disparo_canion
		
		# se ve canion  y oculta la ametralladora
		if sprite_canion:
			sprite_canion.show()
		if sprite_ametralladora:
			sprite_ametralladora.hide()
			


func _on_timer_canion_timeout() -> void:
	if es_ametralladora:
		disparar_ametralladora()
	else:
		disparar_canion()

# Disparo normal
func disparar_canion() -> void:
	if disparo_tomate != null and salida_canion != null:
		var nuevo_tomate = disparo_tomate.instantiate()
		nuevo_tomate.global_position = salida_canion.global_position
		get_tree().current_scene.add_child(nuevo_tomate)


# Disparo ametralladora:
func disparar_ametralladora() -> void:
	if disparo_tomate == null:
		return
		
	var salida = salidas_ametralladora[indice_canion_actual]
	if salida != null:
		var nuevo_tomate = disparo_tomate.instantiate()
		nuevo_tomate.global_position = salida.global_position
		
		# asigna la fuerza:
		nuevo_tomate.fuerza_disparo = fuerzas_disparo[indice_canion_actual]
		
		get_tree().current_scene.add_child(nuevo_tomate)
	
	# va a la siguiente salida del canion:
	indice_canion_actual += 1
	if indice_canion_actual >= salidas_ametralladora.size():
		indice_canion_actual = 0
		


func _on_area_vision_body_entered(body: Node2D) -> void:
	if body is Topi:
		#print("topo en area vision del canion")
		topos_en_area_vision += 1
		if timer_canion.is_stopped():
			timer_canion.start()


func _on_area_vision_body_exited(body: Node2D) -> void:
	if body is Topi:
		topos_en_area_vision -= 1
		if topos_en_area_vision <= 0:
			#print("ya no hay topos en area vision del canion")
			timer_canion.stop()
