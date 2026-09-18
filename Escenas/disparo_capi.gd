extends DisparoBase

class_name DisparoCapi

func _ready() -> void:
	#SUPER READY EJECUTA EL CODIGO DE LA CLASE PADRE, SE BORRA AL SALIR DE LA PANTALLA
	super._ready()
	
	#PERSONALIZAMOS LOS VALORES DEL DISPARO:
	velocidad = 450.0
	danio = 10
	


func _physics_process(delta: float) -> void:
	#El disparo del capi va hacia la derecha hasta que choca con el topi
	global_position.x += velocidad * delta
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Capi or area.get_parent() is PlantaBase:
		return
		
	if area is GestorDeHP:
		area.recibir_danio(danio)
		queue_free()
		return
