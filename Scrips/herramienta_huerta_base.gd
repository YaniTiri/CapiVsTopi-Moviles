extends Node
class_name HerramientaHuertaBase

func soltar_herramienta() -> void:
	var areas_tocadas = $Detector.get_overlapping_areas()
	
	for area in areas_tocadas:
		if area is ParcelaTierra:
			# si es una parcela de tierra, aplica la herramienta y la borra:
			if puede_aplicarse_en(area):
				aplicar_herramienta(area)
				queue_free()
				return
	#print("acá no hay tierra para usar la herramienta")
	queue_free()

#función que cada clase hija va a tener que aplicar:
func aplicar_herramienta(parcela: ParcelaTierra) -> void:
	pass
func puede_aplicarse_en(parcela: ParcelaTierra) -> bool:
	return false
	
#--SHADER:

func _ready() -> void:
	$Detector.area_entered.connect(func(a): _actualizar_efecto_shader())
	$Detector.area_exited.connect(func(a): _actualizar_efecto_shader())
	
func _actualizar_efecto_shader() -> void:
	var sobre_tierra_valida : bool = false
	
	for area in $Detector.get_overlapping_areas():
		if area is ParcelaTierra:
			if puede_aplicarse_en(area):
				sobre_tierra_valida = true
				break
			
	var sprite = get_node_or_null("Sprite2D")
	if sprite and sprite.material:
		var fuerza = 4.5 if sobre_tierra_valida else 0.0
		sprite.material.set_shader_parameter("glow_intensity", fuerza)
