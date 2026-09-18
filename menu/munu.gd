extends Control

func _on_texture_button_3_pressed():
	get_tree().change_scene_to_file("res://credito/credito.tscn")


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/mapa.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_setting_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu_setting.tscn")
