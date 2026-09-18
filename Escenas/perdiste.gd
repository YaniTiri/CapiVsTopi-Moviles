extends Control
@onready var label_monedas_final: Label = $monedas
@onready var label_tomates_final: Label = $tomates
@onready var texto_derrota: Label = $Mensaje_derrota/texto_derrota

func _ready() -> void:
	label_monedas_final.text = str(GameManager.monedas)
	label_tomates_final.text = str(GameManager.tomates_cosechados)
	texto_derrota.text = GameManager.mensaje_derrota


func _on_volver_a_intentar_pressed() -> void:
	GameManager.monedas = 0
	GameManager.topos_derrotados = 0
	GameManager.tomates_cosechados = 0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/nivel_1.tscn")


func _on_ir_a_mapa_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/mapa.tscn")
