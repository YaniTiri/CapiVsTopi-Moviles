extends Control
# Cantidad total de niveles del juego
const TOTAL_NIVELES: int = 11


func _ready() -> void:
	# Recorremos y configuramos automáticamente los 11 niveles
	for i in range(1, TOTAL_NIVELES + 1):
		var ruta_boton: String = "boton_" + str(i)
		var boton: TextureButton = get_node_or_null(ruta_boton) as TextureButton
		
		if boton != null:
			configurar_boton(boton, i)
			# Conectamos la señal 'pressed' de forma dinámica con bind(i)
			if not boton.pressed.is_connected(_on_nivel_pressed):
				boton.pressed.connect(_on_nivel_pressed.bind(i))

# Habilita o bloquea el botón y ajusta el texto visible
func configurar_boton(boton: TextureButton, numero_nivel: int) -> void:
	# Busca el Label hijo
	var label: Label = boton.get_node_or_null("Label")
	if label == null:
		label = boton.get_node_or_null(str(numero_nivel))
	
	# Según el progreso de niveles registrado en GameManager
	if numero_nivel <= GameManager.nivel_maximo_desbloqueado:
		boton.disabled = false
		if label != null:
			label.text = str(numero_nivel)
	else:
		boton.disabled = true
		#Quitar esto despues si agregamos candaditos:
		if label != null:
			label.text = "?"


# Función para entrar a cualquier nivel (1 al 11)
func _on_nivel_pressed(numero_nivel: int) -> void:
	if numero_nivel <= GameManager.nivel_maximo_desbloqueado:
		GameManager.resetear_para_nuevo_nivel()
		GameManager.nivel_actual = numero_nivel
		get_tree().change_scene_to_file("res://Escenas/nivel_" + str(numero_nivel) + ".tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/munu.tscn")
