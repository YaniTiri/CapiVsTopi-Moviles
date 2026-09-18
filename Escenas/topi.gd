extends CharacterBody2D

class_name Topi 

#variables
var tipo_color: String = "normal"
var escena_disparo_topi = preload("res://Escenas/disparo_topi.tscn")
var vida: int= 30
var velocidad_actual: float = -80.0
var estar_enojado: bool = false
var carriles_y: Array[float] = [695.0,735.0,775.0] #Acá cambian de carril,  Posición de las parcelas
var ajuste_visual_y: float = -30.0
var planta_actual: Node2D = null
var gestorHp_planta_actual: Area2D = null
var danio_mordida: int = 10
var tween_enojo: Tween = null

#Funciones
func _ready() -> void: #Con esto nuevo bajan tomando en cuenta las parcelas y se acomodan visualmente
	global_position.y = carriles_y.pick_random() + ajuste_visual_y 
	#$GestorDeHp.area_entered.connect(_on_gestor_de_hp_area_entered)
	#$GestorDeHp.area_exited.connect(_on_gestor_de_hp_area_exited)
	# Al final de la función, evaluamos qué color le asignó el Spawner antes de nacer
	if tipo_color == "verde": 
		$AnimationPlayer.play ("topi_camina_verde")
	elif tipo_color == "amarillo":
		$AnimationPlayer.play ("topi_camina_amarillo")
	else:
		$AnimationPlayer.play("topi_camina")


func _physics_process(delta: float) -> void:
	if planta_actual != null:
		velocity.x = 0
	else:
		velocity.x = velocidad_actual
	move_and_slide()
	
	if vida <= 10 and not estar_enojado:
		ponerse_rojo()
		
#Acá llama a TimerAtaque
func _on_timer_ataque_timeout() -> void:
	if planta_actual != null:
		morder_planta()
	else:
		disparar()
	
func disparar() -> void:
	var bala = escena_disparo_topi.instantiate()
	bala.global_position = global_position
	get_tree().current_scene.add_child(bala)
	$SonidoDisparo.play()

func morder_planta() -> void:
	if is_instance_valid(gestorHp_planta_actual):
		#print("El topo está mordiendo la planta")
		gestorHp_planta_actual.recibir_danio(danio_mordida)
		if gestorHp_planta_actual is EscudoDefensivo:
			$ParticulasMordida2.restart()
		else:
			$ParticulasMordida.restart()
	
func recibir_danio(dmg: int) -> void:
	if vida <= 0:
		return
	vida -= dmg
	#Se estaba duplicando la muerte, 
	#esto en realidad lo maneja el gestor de HP
	#if vida <= 0:
	#	morir() 
	
func ponerse_rojo() -> void:
	estar_enojado = true
	velocidad_actual = -150.0
	tween_enojo = create_tween()
	
	tween_enojo.tween_property($Sprite2D,"modulate", Color(1,0,0),0.5)
	#print("Al fin se calentó este pecho fríooo")
	
func morir() -> void:
	#print ("Topi derrotado")
	if tween_enojo and tween_enojo.is_valid():
		tween_enojo.kill()
	$Sprite2D.modulate = Color(1, 1, 1)
	GameManager.sumar_puntaje_topos()
	
	velocidad_actual = 0.0
	$TimerAtaque.stop()
	
	$CollisionShape2D2.set_deferred("disabled", true)
	if has_node("GestorDeHp/CollisionShape2D2"):
		$GestorDeHp/CollisionShape2D2.set_deferred("disabled", true)
	if has_node("GestorDeHp/CollisionShape2D3"):#NUEVO TODA 
		$GestorDeHp/CollisionShape2D3.set_deferred("disabled", true)
	$AnimationPlayer.get_animation ("Topi_muere").loop_mode = 0
	$AnimationPlayer.play("Topi_muere")
	$SonidoMuerte.play()
	await $AnimationPlayer.animation_finished
	queue_free()
		
func eliminar_todos_los_topos() -> void:
	#los topos se eliminan al terminar el nivel
	queue_free()

func _on_gestor_de_hp_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlantaBase:#Nueva linea
		planta_actual = area.get_parent()
		gestorHp_planta_actual = area
		$TimerAtaque.stop()
		empezar_a_morder()
		
	elif area is EscudoDefensivo: #Destruye al Escudo
		planta_actual = area.get_parent()
		gestorHp_planta_actual = area
		$TimerAtaque.stop()
		empezar_a_morder()
		

func empezar_a_morder() -> void:
	while planta_actual != null and is_instance_valid(gestorHp_planta_actual):
		morder_planta()
		await get_tree().create_timer(1.0).timeout

func _on_gestor_de_hp_area_exited(area: Area2D) -> void:
	if area == gestorHp_planta_actual :
		planta_actual = null
		gestorHp_planta_actual = null
		if is_inside_tree() and $TimerAtaque.is_inside_tree():
			$TimerAtaque.start()
