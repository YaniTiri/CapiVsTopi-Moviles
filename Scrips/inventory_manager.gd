extends Node

# Señales para actualizar la UI (HUD / Cocina / Tienda)
signal fruto_actualizado(id_fruto: String, nueva_cantidad: int)
signal tickets_actualizados(nueva_cantidad: int)
signal decoracion_desbloqueada(id_decoracion: String)
signal ingrediente_actualizado(id_ingrediente: String, nueva_cantidad: int)

#diccionario de los ingredientes comprados para cocinar:
var ingredientes_cocina: Dictionary={
	"agua" = 0,
	"azucar" = 0,
	"aceite" = 0
	
}
#diccionario para los frutos cosechados de cada nivel:
var frutos_cosechados: Dictionary ={
	"tomates" = 0,
	"berenjenas" = 0,
	"ajies" = 0,
	"uvas" = 0,
	"maices" = 0,
	"frutillas" = 0,
	"moras" = 0,
	"calabazas" = 0,
	"arandanos" = 0,
	"cerezas" = 0,
	"fruta_dragon" = 0
}

#diccionario para los productos elaborados en la cocina:
var productos_elaborados: Dictionary ={
	"mermelada_tomates" = 0,
	"conserva_tomates" = 0,
	"conserva_berenjenas" = 0,
	"conserva_ajies" = 0,
	"mermelada_uvas" = 0,
	"conserva_maiz" = 0,
	"mermelada_frutillas" = 0,
	"mermelada_moras" = 0,
	"mermelada_calabazas" = 0,
	"mermelada_arandanos" = 0,
	"mermelada_cerezas" = 0,
	"mermelada_fruta_dragon" = 0
}

#------------------
# funciones frutos:
#------------------
func agregar_fruto(id_fruto: String, cantidad: int) -> void:
	if frutos_cosechados.has(id_fruto):
		frutos_cosechados[id_fruto] += cantidad
		fruto_actualizado.emit(id_fruto, frutos_cosechados[id_fruto])
	else:
		frutos_cosechados[id_fruto] = cantidad
		fruto_actualizado.emit(id_fruto, cantidad)
	print("Fruto cosechado (", id_fruto, " +", cantidad, "). Estado actual: ", frutos_cosechados)


func obtener_cantidad_fruto(id_fruto: String) -> int:
	return frutos_cosechados.get(id_fruto, 0)


func cocinar_fruto(id_fruto: String, cantidad: int) -> bool:
	var actual: int = obtener_cantidad_fruto(id_fruto)
	if actual >= cantidad:
		frutos_cosechados[id_fruto] -= cantidad
		fruto_actualizado.emit(id_fruto, frutos_cosechados[id_fruto])
		print("Fruto consumido (", id_fruto, " -", cantidad, "). Estado actual: ", frutos_cosechados)
		return true
	print("Intento fallido de cocina: ", id_fruto, " insuficientes (tienes ", actual, ", requiere ", cantidad, ")")
	return false

#--------------------------------------------------
# funciones ingredientes (aceite, agua, azucar):
#---------------------------------------------------
func agregar_ingrediente(id: String, cantidad:int) ->void:
	if ingredientes_cocina.has(id):
		ingredientes_cocina[id] += cantidad
		ingrediente_actualizado.emit(id, ingredientes_cocina[id])
	else:
		ingredientes_cocina[id] = cantidad
		ingrediente_actualizado.emit(id, cantidad)
	print("Ingrediente comprado: ", id, " +", cantidad, " (Total: ", ingredientes_cocina[id], ")")

func obtener_ingredientes(id: String) ->int:
	return ingredientes_cocina.get(id, 0)

func cocinar_ingrediente(id: String, cantidad: int) ->bool:
	var actual: int = obtener_ingredientes(id)
	if actual >= cantidad:
		ingredientes_cocina[id] -= cantidad
		ingrediente_actualizado.emit(id, ingredientes_cocina[id])
		return true
	return false


#--------------------------
#TICKETS PARA DECORACIONES:
#--------------------------
var tickets_decoracion: int = 0

func agregar_tickets(cantidad: int) -> void:
	tickets_decoracion += cantidad
	tickets_actualizados.emit(tickets_decoracion)
	print("Tickets agregados (+", cantidad, "). Total: ", tickets_decoracion)

func usar_tickets(cantidad: int) -> bool:
	if tickets_decoracion >= cantidad:
		tickets_decoracion -= cantidad
		tickets_actualizados.emit(tickets_decoracion)
		print("Tickets usados (-", cantidad, "). Restan: ", tickets_decoracion)
		return true
	print("Tickets insuficientes (tienes ", tickets_decoracion, ", y requiere ", cantidad, ")")
	return false
	
#-------------
#DECORACIONES:
#-------------
var decoraciones_desbloqueadas: Dictionary = {
	"repisa_casa": false,
	"sillon_casa": false,
	"libros_casa": false,
	"macetas_casa": false,
	"chimenea_casa": false,
	"mesa_casa": false
}

func desbloquear_decoracion(id_decoracion: String) -> void:
	if decoraciones_desbloqueadas.has(id_decoracion):
		decoraciones_desbloqueadas[id_decoracion] = true
		decoracion_desbloqueada.emit(id_decoracion)
		print("¡Decoración desbloqueada!: ", id_decoracion)
	else:
		decoraciones_desbloqueadas[id_decoracion] = true
		decoracion_desbloqueada.emit(id_decoracion)
		print("Nueva decoración registrada: ", id_decoracion)


func esta_decoracion_desbloqueada(id_decoracion: String) -> bool:
	return decoraciones_desbloqueadas.get(id_decoracion, false)
