extends Node

# Señales para actualizar la UI (HUD / Cocina / Tienda)
signal fruto_actualizado(id_fruto: String, nueva_cantidad: int)

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
