extends HerramientaHuertaBase

func aplicar_herramienta(parcela: ParcelaTierra) -> void:
	parcela.colocar_escudo_piedra()
	
	GameManager.vallas_piedra_actuales(-1)
	


func puede_aplicarse_en(parcela: ParcelaTierra) -> bool:
	return parcela.escudo_actual == null
