extends Marker2D

#Señal para eliminar todos los topos al ganar el nivel:
signal  eliminar_topos_restantes
#CREAMOS LA FABRICA DE ENEMIGOS
var fabrica = FactoryEnemigos.new()
#NIVEL DE DIFICULTAD
@export var dificultad_actual = 1

func _ready() -> void:
	#CONECTAMOS EL TIMER
	$TimerOleada.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	generar_topo()
	#GENERAR ALEATORIEDAD PARA EL TIMER
	var nuevo_tiempo = randf_range(4.0, 6.0)
	#ASIGNAR EL NUEVO TIEMPO AL RELOJ:
	$TimerOleada.wait_time = nuevo_tiempo
	
func generar_topo() -> void:
	#LE INDICAMOS A LA FABRICA QUE CREE UN ENEMIGO
	var nuevo_enemigo = fabrica.crear_enemigo(1)
	
	#SI SE CREO UN ENEMIGO LO UBICAMOS EN LA ESCENA:
	if nuevo_enemigo != null:

		if dificultad_actual == 2:#NUEVO COLORES DE TOPOS
			# Si es el nivel 2, elige al azar entre verde y amarillo
			var colores_posibles = ["verde", "amarillo"]
			nuevo_enemigo.tipo_color = colores_posibles.pick_random()
		else:
			# Para cualquier otro nivel (Nivel 1), va el topo normal
			nuevo_enemigo.tipo_color = "normal"
		#LO COLOCAMOS DONDE ESTÁ EL MARKER2D
		nuevo_enemigo.global_position = global_position
		
		#Conecta la señal para eliminar topos:
		eliminar_topos_restantes.connect(nuevo_enemigo.eliminar_todos_los_topos)
		
		#LO AGREGAMOS COMO HIJO DEL NIVEL 1
		get_parent().add_child(nuevo_enemigo)
