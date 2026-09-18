extends Node2D

var disparo_tomate = preload("res://Escenas/disparo_tomate.tscn")
@onready var timer_canion: Timer = $TimerCanion
@onready var salida_canion: Marker2D = $SalidaCanion

var topos_en_area_vision: int = 0

func _ready() -> void:
	timer_canion.timeout.connect(_on_timer_canion_timeout)
	#timer_canion.start()


func _on_timer_canion_timeout() -> void:
	disparar_tomate()

func disparar_tomate() -> void:
	if disparo_tomate != null:
		var nuevo_tomate = disparo_tomate.instantiate()
		nuevo_tomate.global_position = salida_canion.global_position
		get_tree().current_scene.add_child(nuevo_tomate)
		


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
