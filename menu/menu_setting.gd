extends Control

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_command_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/comando.tscn")


func _on_ig_link_pressed() -> void:
	OS.shell_open("https://www.instagram.com/zero_logic_studio?obrf=MW5jdWJ2MjRraGd5YQ==")




func _on_musica_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Musica")
	if bus_idx != -1:
		if value <= 0.05:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
			
func _on_sfx_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("SFX")
	if bus_idx != -1:
		if value <= 0.05:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
func _on_sacar_menu_pressed() -> void:
	cerrar_menu()

# Asegúrate de ajustar el punto de pivote al centro en el Inspector
func _ready() -> void:
	# Ajustamos el pivote al centro de la ventana para que se minimice hacia el centro
	pivot_offset = size / 2

# Función para cerrar/minimizar el menú
func cerrar_menu() -> void:
	var tween = create_tween().set_parallel(true)
	# Anima la escala a 0 en 0.25 segundos con efecto suave
	tween.tween_property(self, "scale", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN)
	# Al finalizar la animación, ocultamos el nodo
	await tween.finished
	hide()

# Función para abrir/mostrar el menú
func abrir_menu() -> void:
	show()
	scale = Vector2.ZERO
	modulate.a = 0.0
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT)


func _on_master_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx != -1:
		if value <= 0.05:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
