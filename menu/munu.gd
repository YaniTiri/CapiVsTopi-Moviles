extends Control
@onready var menu_setting: Control = $menu_setting
@onready var btn_setting: TextureButton = $Setting

func _ready() -> void:
	# Ocultamos el menú al arrancar si no está oculto
	menu_setting.visible = false
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_setting_pressed() -> void:
	menu_setting.visible = true

func _on_mapa_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/mapa.tscn")
