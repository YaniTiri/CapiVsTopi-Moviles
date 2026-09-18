extends Area2D
class_name GestorDeHP

#VARIABLES
#@export var grupo_que_dania: String = "balas_enemigas"
var max_hp: int
var actual_hp: int

#SEÑALES
signal impacto_recibido(hp: int)
signal muerte

#FUNCIONES
func _ready() -> void:
	#TOMA DEL NODO PADRE SU VARIABLE DE VIDA INICIAL
	max_hp = get_parent().vida
	actual_hp = max_hp
		
	#CUANDO LA VIDA LLEGA A 0 LE AVISA AL PADRE QUE EJECUTE LA FUNCION MORIR
	muerte.connect(get_parent().morir)
	
	#Verifica si entró un disparo
#func _on_area_entered(area: Area2D) -> void:
#		if area.is_in_group(grupo_que_dania):
#			recibir_danio(10) #Ahora llamamos a la función recibir_danio
#			area.queue_free() #Borramos la bala para que no atraviese al enemigo

		
func recibir_danio (dmg: int) -> void:
		actual_hp -= dmg
		impacto_recibido.emit (actual_hp)
		print(get_parent().name, " recibió daño. vida restante : " , actual_hp)
	
		if get_parent().has_method("recibir_danio"): #Le avisamos al padre que se fije si tiene que ponerse rojo
			get_parent().recibir_danio(dmg)  #Le pasamos el daño para que el scrip Topi ejecute su lógica de Tween

		chequear_muerte()

func chequear_muerte() -> void:
		if actual_hp <=0:
			muerte.emit()
