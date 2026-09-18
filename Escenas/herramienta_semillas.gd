extends HerramientaHuertaBase

func aplicar_herramienta(parcela: ParcelaTierra) -> void:
	parcela.sembrar()
	
func puede_aplicarse_en(parcela: ParcelaTierra) -> bool:
	return parcela.planta_actual == null
	
