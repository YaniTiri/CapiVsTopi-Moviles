extends Area2D

func recibir_danio_planta(danio: int) -> void:
	var gestor = owner.get_node("GestorDeHp")
	if gestor != null:
		gestor.recibir_danio(danio)
