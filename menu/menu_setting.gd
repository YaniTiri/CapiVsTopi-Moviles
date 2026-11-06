extends Control
@onready var btn_sacar_menu: TextureButton = $SacarMenu

func _ready() -> void:
	btn_sacar_menu.pressed.connect(func(): visible = false)
	
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

func _on_master_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx != -1:
		if value <= 0.05:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))

func _on_sacar_menu_pressed() -> void:
	visible = false
