extends CanvasLayer

func _ready() -> void:
	visible = false
	GameManager.pausar_despausar.connect(_on_pausar_o_despausar_juego)
	
		
func _on_pausar_o_despausar_juego(estado: bool) -> void:
	visible = estado
	
	

func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_play_pressed() -> void:
	GameManager.pausar_o_despausar_global()


#func _on_setting_pressed() -> void:
#	GameManager.pausar_o_despausar_global()
#	get_tree().change_scene_to_file("res://menu/menu_setting.tscn")


func _on_back_menu_pressed() -> void:
	GameManager.pausar_o_despausar_global()
	get_tree().change_scene_to_file("res://Escenas/mapa.tscn")
