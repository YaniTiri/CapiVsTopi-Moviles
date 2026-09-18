extends Control


func _on_back_comma_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu_setting.tscn")
