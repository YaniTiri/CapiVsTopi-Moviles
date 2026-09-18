extends HerramientaHuertaBase

func aplicar_herramienta(parcela: ParcelaTierra) -> void:
	parcela.sembrar_super_semilla()
	GameManager.semillas_poderosas_actuales(-1)
	
func puede_aplicarse_en(parcela: ParcelaTierra) -> bool:
	return parcela.planta_actual == null
