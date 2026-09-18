extends CanvasLayer

@onready var label_topos: Label = $oleadaTopos

func _ready() -> void:
	
	GameManager.actualizar_topos.connect(actualizar_texto_topos)
	actualizar_texto_topos(GameManager.topos_derrotados)
	
func actualizar_texto_topos(topos_muertos: int) ->void:
	label_topos.text = str(GameManager.topos_derrotados) + " / " + str(GameManager.topos_muertos_por_nivel)
