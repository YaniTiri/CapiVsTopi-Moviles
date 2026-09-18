extends Control

@onready var boton_nivel_2: TextureButton = $"boton_2"
@onready var label_boton_nivel_2: Label = $"boton_2/2"

func _ready() -> void:
	if GameManager.nivel_1_completado == false:
		boton_nivel_2.disabled = true
		label_boton_nivel_2.text = "?"
	else:
		boton_nivel_2.disabled= false
		label_boton_nivel_2.text = "2"

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/munu.tscn")


func _on_boton_1_pressed() -> void:
	GameManager.resetear_para_nuevo_nivel()
	get_tree().change_scene_to_file("res://Escenas/nivel_1.tscn")


func _on_boton_2_pressed() -> void:
	if GameManager.nivel_1_completado == true:
		GameManager.resetear_para_nuevo_nivel()
		get_tree().change_scene_to_file("res://Escenas/nivel_2.tscn")
