extends Node
class_name FactoryEnemigos

#CARGAMOS LOS DIFERENTES ENEMIGOS, POR AHORA HAY UN SOLO TIPO DE TOPO:
var topi_base = preload("res://Escenas/topi.tscn")

func crear_enemigo(nivel_dificultad: int) -> Topi:
	var nuevo_topo: Topi
	
	match nivel_dificultad:
		1:
			#PARA EL NIVEL 1 CREAMOS EL TOPO COMUN:
			nuevo_topo = topi_base.instantiate()
		#2: CUANDO HAGAMOS MÁS TOPOS VER SOLUCION COMPONENTES Y FACTORY GODOT
	return nuevo_topo
		
	
	
