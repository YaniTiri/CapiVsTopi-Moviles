extends CanvasLayer


@onready var label_monedas: Label = $monedas

func _ready() -> void:
	label_monedas.text = str(GameManager.monedas)
	GameManager.actualizar_monedas.connect(actualizar_texto_monedas)
	
func actualizar_texto_monedas(nueva_cantidad: int) ->void:
	label_monedas.text = str(nueva_cantidad)
