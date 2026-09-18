extends Node2D

@onready var boton_canion: TextureButton = $BotonCanion
@onready var boton_super_semillas: TextureButton = $BotonSuperSemillas
@onready var boton_escudo: TextureButton = $BotonValla


func _ready() -> void:
	#GameManager.monedas=30
	actualizar_botones()

func actualizar_botones() -> void:
	boton_canion.disabled = GameManager.mejoras_desbloqueadas["canion_techo"] or GameManager.monedas < GameManager.precios_mejoras["canion_techo"]
	boton_super_semillas.disabled = GameManager.mejoras_desbloqueadas["semillas_poderosas"] or GameManager.monedas < GameManager.precios_mejoras["semillas_poderosas"]
	boton_escudo.disabled = GameManager.mejoras_desbloqueadas["herramienta_escudo"] or GameManager.monedas < GameManager.precios_mejoras["herramienta_escudo"]
	
	boton_canion.modulate = Color(0.5, 0.5, 0.5) if boton_canion.disabled else Color(1, 1, 1)
	boton_super_semillas.modulate = Color(0.5, 0.5, 0.5) if boton_super_semillas.disabled else Color(1, 1, 1)
	boton_escudo.modulate = Color(0.5, 0.5, 0.5) if boton_escudo.disabled else Color(1, 1, 1)


func _on_texture_button_pressed() -> void:
	GameManager.tienda_comprar("canion_techo")
	actualizar_botones()


func _on_texture_button_2_pressed() -> void:
	GameManager.tienda_comprar("semillas_poderosas")
	if GameManager.mejoras_desbloqueadas["semillas_poderosas"] == true:
		GameManager.semillas_poderosas_actuales(10)
	actualizar_botones()
	

func _on_texture_button_3_pressed() -> void:
	GameManager.tienda_comprar("herramienta_escudo")
	actualizar_botones()


func _on_siguiente_nivel_pressed() -> void:
	#Pasa al nivel que guardamos en el Game Manager al momento de la victoria anterior
	get_tree().change_scene_to_file(GameManager.ruta_siguiente_nivel)
