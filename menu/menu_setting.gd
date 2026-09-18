extends Control


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/munu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_command_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/comando.tscn")
