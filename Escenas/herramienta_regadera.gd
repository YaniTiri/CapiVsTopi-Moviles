extends HerramientaHuertaBase

func aplicar_herramienta(parcela: ParcelaTierra) -> void:
	parcela.regar()

func puede_aplicarse_en(parcela: ParcelaTierra) -> bool:
	if parcela.planta_actual != null and parcela.planta_actual is PlantaBase:
		# ...brilla SOLO si NO está en la fase cosechable
		return parcela.planta_actual.fase_actual != PlantaBase.FasePlanta.COSECHABLE
	
	return false
