extends Node2D
class_name PlantaBase

#Para el gestor de hp:
var vida: int = 30

#Para la animacion de la moneda:
var moneda_animacion = preload("res://Escenas/moneda_anim.tscn")

#Fases de las plantas:
enum FasePlanta { BROTE, CRECIENDO, COSECHABLE }

var fase_actual: FasePlanta = FasePlanta.BROTE

#IMAGENES SPRITE:
@onready var sprite_brote: Sprite2D = $SpriteBrote
@onready var sprite_creciendo: Sprite2D = $SpriteCreciendo
@onready var sprite_cosechable: Sprite2D = $SpriteCosechable

#Gestor de HP para actualizar vida:
@onready var gestor_hp = $GestorDeHp


func _ready() -> void:
	add_to_group("plantas")
	actualizar_dibujo()
	
func actualizar_dibujo() -> void:
	#INICIAN LOS SPRITES OCULTOS
	sprite_brote.hide()
	sprite_creciendo.hide()
	sprite_cosechable.hide()
	
	match fase_actual:
		#SEGÚN LA FASE DE LA PLANTA SE MUESTRA EL SPRITE CORRECTO:
		FasePlanta.BROTE:
			sprite_brote.show()
			#print("planta brote")
		FasePlanta.CRECIENDO:
			sprite_creciendo.show()
			#print("planta creciendo")
		FasePlanta.COSECHABLE:
			sprite_cosechable.show()
			#print("planta cosechable")
			
func regar() -> void:
	if fase_actual == FasePlanta.BROTE:
		fase_actual = FasePlanta.CRECIENDO
		actualizar_dibujo()
		GameManager.sumar_monedas_huerta(10)
		aparecer_moneda()
		gestor_hp.actual_hp+=10
	elif fase_actual == FasePlanta.CRECIENDO:
		fase_actual = FasePlanta.COSECHABLE
		GameManager.sumar_monedas_huerta(20)
		actualizar_dibujo()
		aparecer_moneda()
		gestor_hp.actual_hp+=20
		
func activar_auto_crecimiento() -> void:
	var timer_auto_riego = Timer.new()
	timer_auto_riego.wait_time = 4.0
	timer_auto_riego.autostart = true
	add_child(timer_auto_riego)
	#bind envia el timer como parametro a la funcion del timeout
	timer_auto_riego.timeout.connect(_on_timer_auto_riego_timeout.bind(timer_auto_riego))

func _on_timer_auto_riego_timeout(timer: Timer) -> void:
	if fase_actual != FasePlanta.COSECHABLE:
		regar()
	else:
		#borra el timer auto riego
		timer.queue_free()

func cosechar() -> bool:
	if fase_actual == FasePlanta.COSECHABLE:
		#print("planta cosechada")
		GameManager.sumar_monedas_huerta(30)
		GameManager.tomates_cosechados += 1
		aparecer_moneda()
		return true
	else:
		return false

func recibir_danio(dmg:int) -> void:
	vida-=dmg
	#print("planta recibió daño")
	
	var sprite_activo : Sprite2D = null
	if sprite_brote.visible: sprite_activo = sprite_brote
	elif sprite_creciendo.visible: sprite_activo = sprite_creciendo
	elif sprite_cosechable.visible: sprite_activo = sprite_cosechable
		
	if sprite_activo != null:
		var tween = create_tween() 

		tween.tween_property (sprite_activo, "modulate", Color (1,0,0), 0.1 )

		tween.parallel().tween_property(sprite_activo,"position:x", 5.0 , 0.05   ).as_relative()
		tween.tween_property(sprite_activo,"position:x", -10.0 , 0.05   ).as_relative()
		tween.tween_property(sprite_activo,"position:x", 5.0 , 0.05   ).as_relative() # Efecto sacudida
			
		tween.tween_property (sprite_activo, "modulate", Color (1,1,1), 0.1 )

func aparecer_moneda():
	#instancia la animacion de la moneda
	var nueva_moneda = moneda_animacion.instantiate()
	#lo hacemos hijo de la planta
	get_parent().add_child(nueva_moneda)
	#le damos la posicion de la planta
	nueva_moneda.global_position = global_position
	#print("Moneda creada en: ", global_position)

func morir() -> void:
	#print("el topo mató la planta")
	
	if GameManager.has_method("registrar_planta_destruida"):
		GameManager.registrar_planta_destruida()
	queue_free()
