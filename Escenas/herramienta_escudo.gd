extends  HerramientaHuertaBase

func aplicar_herramienta(parcela: ParcelaTierra) -> void:
	parcela.colocar_escudo()
	
func puede_aplicarse_en(parcela: ParcelaTierra) -> bool:
	return parcela.planta_actual == null and parcela.escudo_actual == null
	
