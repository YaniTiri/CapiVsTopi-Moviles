extends Node

#VARIABLES GLOBALES
var nivel_actual: int = 1
var nivel_maximo_desbloqueado: int = 1
var topos_derrotados: int = 0
var monedas: int = 0
var plantas_destruidas: int = 0
var limite_de_plantas_para_perder : int= 50 #Si topi rompe 50 plantas Capi pierde
var tomates_cosechados: int = 0
var logro_20_plantas_desbloqueado: bool = false
var ruta_siguiente_nivel: String = ""
var topos_muertos_por_nivel: int = 10 #Acá puse la cantidad del nivel 1
var mensaje_derrota: String = ""
var semillas_poderosas: int = 0
var logro_rico_desbloqueado: bool = false
var nivel_1_completado: bool = false
var planta_del_nivel: PackedScene  = preload("res://Escenas/planta_base.tscn")
var escena_popup: PackedScene = preload("res://Escenas/popup_desbloqueos.tscn")
var frutos_cosechados_en_nivel: int = 0
var pociones_curativas: int = 0
var bombas_anti_topos: int = 0
var vallas_piedra: int = 0


#Diccionario de mejoras para comprar con monedas:
var mejoras_desbloqueadas: Dictionary ={
	"canion_techo": false,
	"semillas_poderosas": false, 
	"herramienta_escudo": false, 
	"pocion_curativa": false,
	"escudo_piedra": false,
	"bomba_anti_topos": false,
	"ametralladora_canion": false 
}
#diccionario para los precios de la tienda:
var precios_mejoras: Dictionary={
	"canion_techo": 150,
	"semillas_poderosas": 100,
	"herramienta_escudo": 100,
	"agua": 50,
	"azucar": 50,
	"aceite": 50,
	"pocion_curativa": 80,
	"escudo_piedra": 200,
	"bomba_anti_topos": 500,
	"ametralladora_canion": 800 
}



#SEÑALES
signal actualizar_vida_capi(hp_actual: int)
signal actualizar_topos(cantidad: int) 
signal actualizar_monedas(cantidad: int)
signal game_over
signal pausar_despausar(estado: bool)
signal actualizar_semillas_poderosas(cantidad: int)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(_delta: float) -> void:
	if estamos_en_algun_menu():
		return
		
	if Input.is_action_just_pressed("pausa"):
		pausar_o_despausar_global()


#Diccionario frutos por nivel:
var nombre_fruto_por_nivel: Dictionary = {
	1: "Tomates",
	2: "Berenjenas",
	3: "Ajíes",
	4: "Uvas",
	5: "Maíces",
	6: "Frutillas",
	7: "Moras",
	8: "Calabazas",
	9: "Arándanos",
	10: "Cerezas",
	11: "Frutas Dragón"
}

#Aca vienen las funciones
func obtener_nombre_fruto_nivel() -> String:
	return nombre_fruto_por_nivel.get(nivel_actual, "Frutos")

func estamos_en_algun_menu() -> bool:
	var escena_actual = get_tree().current_scene
	
	if not escena_actual:
		return false
	
	var ruta = escena_actual.scene_file_path.to_lower()
	
	if "munu" in ruta or "menu" in ruta or "perdiste" in ruta or "splash" in ruta or "completado" in ruta or "credito" in ruta:
		return true
	
	return false
	
func pausar_o_despausar_global() -> void:
	var estado = !get_tree().paused
	get_tree().paused = estado
	pausar_despausar.emit(estado)
	
func registrar_planta_destruida() -> void:
	plantas_destruidas += 1
	var plantas_instanciadas = get_tree().get_nodes_in_group("plantas").size()
	if plantas_destruidas >= limite_de_plantas_para_perder and plantas_instanciadas <=1:
		mensaje_derrota = "Perdiste! los topos destrozaron demasiadas plantas!"
		activar_game_over()
		
func activar_game_over() -> void:
	plantas_destruidas= 0
	monedas = 0
	tomates_cosechados = 0
	limpiar_mejoras()
	game_over.emit()
	get_tree().call_deferred("change_scene_to_file", "res://Escenas/perdiste.tscn")
	
		
#SEPARO EL PUNTAJE DE TOPOS DERROTADOS DE LAS MONEDAS QUE VA A DAR LA HUERTA
func sumar_puntaje_topos():
	topos_derrotados += 1
	actualizar_topos.emit(topos_derrotados)
	#print("topos derrotados: ", topos_derrotados)
	
func sumar_monedas_huerta(cantidad: int):
	monedas += cantidad
	actualizar_monedas.emit(monedas)
	#print("Monedas Actuales: ", monedas)
	
func semillas_poderosas_actuales(cantidad: int):
	semillas_poderosas += cantidad
	if semillas_poderosas <= 0:
		semillas_poderosas = 0
		mejoras_desbloqueadas["semillas_poderosas"] = false
		
	actualizar_semillas_poderosas.emit(semillas_poderosas)

# Valla de piedra:
func vallas_piedra_actuales(cantidad: int):
	vallas_piedra += cantidad
	if vallas_piedra <= 0:
		vallas_piedra = 0
		mejoras_desbloqueadas["valla_piedra"] = false

# Bomba anti topos:
func bombas_actuales(cantidad: int):
	bombas_anti_topos += cantidad
	if bombas_anti_topos <= 0:
		bombas_anti_topos = 0
		mejoras_desbloqueadas["bomba_anti_topos"] = false

# Poción curativa:
func pociones_actuales(cantidad: int):
	pociones_curativas += cantidad
	if pociones_curativas <= 0:
		pociones_curativas = 0
		mejoras_desbloqueadas["pocion_curativa"] = false

func resetear_para_nuevo_nivel():
	topos_derrotados = 0
	plantas_destruidas = 0
	topos_muertos_por_nivel = 0
	frutos_cosechados_en_nivel = 0
	#####
	#Chequear si suman las semillas que me quedaron y se pueden comprar más
	#semillas_poderosas = 0
	semillas_poderosas_actuales(0)
	mejoras_desbloqueadas["semillas_poderosas"] = false
	######
	#print("variables topos y plantas derrotados a CERO")
	
func tienda_comprar(item: String) -> bool:
	var precio = precios_mejoras[item]
	
	if monedas >= precio and mejoras_desbloqueadas[item] == false:
		monedas -= precio
		mejoras_desbloqueadas[item] = true
		actualizar_monedas.emit(monedas)
		print("Compra exitosa! Desbloqueaste: ", item)
		return true
	else:
		print("No tenes suficientes monedas o ya lo tenes")
		return false
		
func limpiar_mejoras() -> void:
	for item in mejoras_desbloqueadas:
		mejoras_desbloqueadas[item] = false
	semillas_poderosas = 0
	semillas_poderosas_actuales(0)
		
func registrar_cosecha_tomate() -> void:
	tomates_cosechados += 1
	frutos_cosechados_en_nivel += 1
	if tomates_cosechados >= 20 and not logro_20_plantas_desbloqueado:
		logro_20_plantas_desbloqueado = true

func obtener_total_logros() -> int:
	var cuenta = 0
	if logro_20_plantas_desbloqueado: cuenta += 1
	if logro_rico_desbloqueado: cuenta += 1
	return cuenta

#-----------------------------------------------
#FUNCION PARA REGISTRAR NIVELES AVANZADOS:
#-----------------------------------------------
func registrar_nivel_ganado(numero_nivel: int) -> void:
	if numero_nivel >= nivel_maximo_desbloqueado:
		nivel_maximo_desbloqueado = numero_nivel + 1
		print("¡Nuevo nivel máximo desbloqueado!: ", nivel_maximo_desbloqueado)

#-----------------------------------------------
#FUNCION PARA MOSTRAR EL POP UP DE DESBLOQUEOS:
#-----------------------------------------------
func obtener_premio_nivel(nivel: int) -> String:
	var premios: Dictionary = {
		1: "¡Desbloqueaste las semillas de Berenjena y nuevas recetas en la cocina!",
		2: "¡Desbloqueaste las semillas de Ají!",
		3: "¡Desbloqueaste una nueva mejora en la Tienda!",
		4: "¡Desbloqueaste las semillas de Choclo!",
		5: "¡Desbloqueaste nuevas decoraciones para la Casita!",
		6: "¡Desbloqueaste las semillas de Lechuga!",
		7: "¡Desbloqueaste mejoras avanzadas en la Tienda!",
		8: "¡Desbloqueaste las semillas de Frutilla!",
		9: "¡Desbloqueaste recetas especiales de cocina!",
		10: "¡Desbloqueaste las semillas doradas!",
		11: "¡Felicitaciones! ¡Completaste todos los niveles de la huerta!"
	}
	return premios.get(nivel, "")
	
func mostrar_desbloqueo(titulo: String, mensaje: String) -> PopupDesbloqueo:
	var popup = escena_popup.instantiate()
	get_tree().current_scene.add_child(popup)
	popup.configurar(titulo, mensaje)
	return popup
