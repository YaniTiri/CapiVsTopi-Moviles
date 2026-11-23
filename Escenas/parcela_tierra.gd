extends Area2D
class_name ParcelaTierra

#var planta_scene = preload("res://Escenas/planta_base.tscn")
var escudo_scene = preload("res://Escenas/escudo.tscn")
var escudo_piedra_scene = preload("res://Escenas/herramienta_escudo_piedra.tscn")

var planta_actual: Node2D = null
var escudo_actual: Node2D = null


func _ready() -> void:
	pass

func sembrar() -> void:
	#si la parcela esta vacia plantamos la semilla:
	if planta_actual == null:
		planta_actual = GameManager.planta_del_nivel.instantiate()
		#va como hijo de la parcela para que crezca en el mismo lugar:
		add_child(planta_actual)
	else:
		print("ya hay una planta acá")

func sembrar_super_semilla() -> void:
	#si la parcela esta vacia plantamos la semilla:
	if planta_actual == null:
		planta_actual = GameManager.planta_del_nivel.instantiate()
		add_child(planta_actual)
		#autoriego modo on:
		if planta_actual.has_method("activar_auto_crecimiento"):
			planta_actual.activar_auto_crecimiento()
	

func regar() -> void:
	if planta_actual != null:
		planta_actual.regar()
		$SonidoRegar.play()
	else:
		print("error al regar")
		
func cosechar() -> void:
	if planta_actual != null:
		var se_cosecho = planta_actual.cosechar()
	
		if se_cosecho:
			planta_actual.queue_free()
			planta_actual = null
			$SonidoCosechar.play()
		else:
			print("no se pudo cosechar")
			
func colocar_escudo() -> void: 
	if escudo_actual == null:
		escudo_actual = escudo_scene.instantiate()
		add_child(escudo_actual)
		escudo_actual.position.x = 35
		escudo_actual.position.y = -35
		

func colocar_escudo_piedra() -> void:
	if escudo_actual == null:
		escudo_actual = escudo_scene.instantiate()
		add_child(escudo_actual)
		escudo_actual.position.x = 35
		escudo_actual.position.y = -35
		# dar más vida:
		escudo_actual.vida_maxima = 300
		escudo_actual.vida_actual = 300
		# cambia textura:
		escudo_actual.get_node("Sprite2D").texture = load("res://Assets/vallaPiedra.png")

		


func _on_boton_bomba_pressed() -> void:
	pass # Replace with function body.
