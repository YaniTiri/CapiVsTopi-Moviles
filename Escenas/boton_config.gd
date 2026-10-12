extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	GameManager.pausar_o_despausar_global()
