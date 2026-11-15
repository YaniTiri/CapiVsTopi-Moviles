extends Control
@onready var label_monedas_final: Label = $monedas
@onready var label_frutos_final: Label = $frutos
#@onready var logro_nodo: Label = $logro
@onready var label_topos_final: Label = $logro


func _on_volve_a_intentar_pressed() -> void:
	GameManager.resetear_para_nuevo_nivel()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/nivel_" + str(GameManager.nivel_actual) + ".tscn")


func _on_siguiente_nivel_pressed() -> void:
	GameManager.resetear_para_nuevo_nivel()
	get_tree().change_scene_to_file("res://Escenas/tienda.tscn")


func _ready() -> void:
	if GameManager.monedas >= 1000:
		GameManager.logro_rico_desbloqueado = true
	
	#Monedas obtenidas:
	label_monedas_final.text = str(GameManager.monedas)
	#Frutos cosechados:
	var nombre_fruto = GameManager.obtener_nombre_fruto_nivel()
	label_frutos_final.text = str(GameManager.frutos_cosechados_en_nivel)
	#var logros_conseguidos = GameManager.obtener_total_logros()
	#logro_nodo.text = str(logros_conseguidos) + " / 2"
	#logro_nodo.visible = true
	#Topos derrotados:
	label_topos_final.text = str(GameManager.topos_derrotados)
	label_topos_final.visible = true

func _on_ir_a_mapa_pressed() -> void:
	GameManager.resetear_para_nuevo_nivel() 
	get_tree().change_scene_to_file("res://Escenas/mapa.tscn")
